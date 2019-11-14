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
                 csv_import_id:,
                 import_file_path: ENV['IMPORT_FILE_PATH'] || '/opt/data',
                 error_stream: Darlingtonia.config.default_error_stream,
                 info_stream:  Darlingtonia.config.default_info_stream,
                 **opts)
    self.error_stream = error_stream
    self.info_stream  = info_stream
    @csv_import_id = csv_import_id
    @import_file_path = import_file_path
    @collections_needing_reindex = Set.new
    @works_needing_ordering = Set.new
    @manifests_needing_build = Set.new

    self.validators = []

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

  # Creates IIIF Manifests for each Work in a CSV. Does not create documents
  # for Collection or ChildWork objects.
  def build_iiif_manifests
    CsvImportCreateManifest.where(csv_import_id: @csv_import_id, status: ['queued', 'in progress']).each do |create_manifest_object|
      CreateManifestJob.perform_now(Ark.ensure_prefix(create_manifest_object.ark), create_manifest_object_id: create_manifest_object.id)
    end
  end

  # Given an array of Work arks that have had ChildWorks added to them during this import,
  # iterate through each and use the PageOrder objects to ensure the ChildWorks are
  # in the right order. In other works, ensure a manuscript's pages are ordered by the
  # values in `Item Sequence`
  def order_child_works
    CsvImportOrderChild.where(csv_import_id: @csv_import_id, status: ['queued', 'in progress']).each do |order_children|
      Californica::OrderChildWorksService.new(order_children).order
    end
  end

  def add_finalization_tasks(row)
    case row['Object Type']
    when 'Collection'
      CsvCollectionReindex.create(csv_import_id: @csv_import_id, ark: row['Item ARK'], status: 'queued')
    when 'Work', 'Manuscript'
      CsvCollectionReindex.create(csv_import_id: @csv_import_id, ark: row['Parent ARK'], status: 'queued')
      CsvImportOrderChild.create(csv_import_id: @csv_import_id, ark: row['Item ARK'], status: 'queued')
      CsvImportCreateManifest.create(csv_import_id: @csv_import_id, ark: row['Item ARK'], status: 'queued')
    when 'ChildWork', 'Page'
      CsvImportOrderChild.create(csv_import_id: @csv_import_id, ark: row['Parent ARK'], status: 'queued')
      CsvImportCreateManifest.create(csv_import_id: @csv_import_id, ark: row['Item ARK'], status: 'queued')
      CsvImportCreateManifest.create(csv_import_id: @csv_import_id, ark: row['Parent ARK'], status: 'queued')
    else
      raise ArgumentError, "Unknown Object Type #{row['Object Type']}"
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
    CsvCollectionReindex.where(csv_import_id: @csv_import_id, status: ['queued', 'in progress']).each do |collection_reindex|
      ReindexCollectionJob.perform_now(collection_reindex.id)
    end
  end

  def records
    return enum_for(:records) unless block_given?
    file.rewind
    CSV.parse(file.read, headers: true).each_with_index do |row, index|
      next unless index >= skip
      next if row.to_h.values.all?(&:nil?)

      # use the CalifornicaMapper
      mapper = CalifornicaMapper.new(import_file_path: @import_file_path, row_number: index + 1)

      # Gather all collection objects that have been touched during this import so we can reindex them all at the end
      add_finalization_tasks(row)

      yield Darlingtonia::InputRecord.from(metadata: row, mapper: mapper)
    end
  rescue CSV::MalformedCSVError
    # error reporting for this case is handled by validation
    []
  end
end
