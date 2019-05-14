# frozen_string_literal: true

class CalifornicaCsvParser < Darlingtonia::CsvParser
  ##
  # @!attribute [rw] error_stream
  #   @return [#<<]
  # @!attribute [rw] info_stream
  #   @return [#<<]
  attr_accessor :error_stream, :info_stream, :import_file_path

  ##
  # @todo should error_stream and info_stream be moved to the base
  #   `Darlingtonia::Parser`?
  #
  # @param [#<<] error_stream
  # @param [#<<] info_stream
  def initialize(file:,
                 import_file_path: ENV['IMPORT_FILE_PATH'] || '/opt/data',
                 error_stream: Darlingtonia.config.default_error_stream,
                 info_stream:  Darlingtonia.config.default_info_stream,
                 **opts)
    self.error_stream = error_stream
    self.info_stream  = info_stream
    @import_file_path = import_file_path
    @collections_needing_reindex = []
    # An array of work ids with attached ChildWorks, which might need a reordering of the attached ChildWorks
    @works_needing_ordering = []

    self.validators = [
      Darlingtonia::CsvFormatValidator.new(error_stream: error_stream),
      CsvValidator.new(error_stream: error_stream),
      Darlingtonia::TitleValidator.new(error_stream: error_stream)
    ]

    super
  end

  # Skip this number of records before starting the ingest process. Default is 0.
  # Useful for re-starting a failed ingest without having to blow everything away.
  def skip
    return 0 unless ENV['SKIP']
    ENV['SKIP'].to_s.to_i
  end

  def headers
    return @headers if @headers
    file.rewind
    first_row = file.readline
    @headers = CSV.parse(first_row, headers: true, return_headers: true).headers
  rescue CSV::MalformedCSVError
    # This error will be handled by Darlingtonia::CsvFormatValidator
    []
  end

  # Given an array of Work arks that have had ChildWorks added to them during this import,
  # iterate through each and use the PageOrder objects to ensure the ChildWorks are
  # in the right order. In other works, ensure a manuscript's pages are ordered by the
  # values in `Item Sequence`
  def order_child_works
    works_arks = @works_needing_ordering.reject(&:blank?).uniq
    works_arks.each do |work_ark|
      page_orderings = PageOrder.where(parent: Ark.ensure_prefix(work_ark))
      ordered_arks = page_orderings.sort_by(&:sequence)
      work = Work.find_by_ark(Ark.ensure_prefix(work_ark))
      work.ordered_members = ordered_arks.map { |b| ChildWork.find_by_ark(b.child) }
      work.save
    end
  end

  # Given an array of ARKs:
  #   1. Remove any blanks
  #   2. deduplicate the list
  #   3. find any matching collection objects
  #   4. reindex any matching collection objects
  # This is so we can remove expensive collection reindexing behavior during
  # ingest and only add it back after the ingest is complete.
  def reindex_collections
    list = @collections_needing_reindex.reject(&:blank?).uniq
    list.each do |ark|
      collection = Collection.find_by_ark(Ark.ensure_prefix(ark))
      unless collection
        Rails.logger.error "Tried to reindex collection with ark #{ark} but could not find one."
        next
      end
      collection.recalculate_size = true
      collection.save # The save should kick off a reindex
    end
  end

  def records
    return enum_for(:records) unless block_given?
    file.rewind
    CSV.parse(file.read, headers: true).each_with_index do |row, index|
      next unless index >= skip
      next if row.to_h.values.all?(&:nil?)
      # use the CalifornicaMapper
      yield Darlingtonia::InputRecord.from(metadata: row, mapper: CalifornicaMapper.new(import_file_path: @import_file_path))
      # Gather all collection objects that have been touched during this import so we can reindex them all at the end
      @collections_needing_reindex << row["Item Ark"] if row["Object Type"] == "Collection"
      @collections_needing_reindex << row["Parent ARK"] if row["Object Type"] == "Work"
      @works_needing_ordering << row["Parent ARK"] if row["Object Type"] == "Page"
    end
  rescue CSV::MalformedCSVError
    # error reporting for this case is handled by validation
    []
  end
end
