# frozen_string_literal: true

# Validate a CSV file.
#
# Don't put expensive validations in this class.
# This is meant to be used for running a few quick
# validations before starting a CSV-based import.
# It will be called during the HTTP request/response,
# so long-running validations will make the page load
# slowly for the user.  Any validations that are slow
# should be run in background jobs during the import
# instead of here.

OBJECT_TYPES = ['Collection', 'Work', 'ChildWork', 'Manuscript', 'Page'].freeze

REQUIRED_HEADERS = [
  'Item ARK',
  'Title',
  'Object Type',
  'Parent ARK',
  'File Name'
].freeze

REQUIRED_VALUES = [
  ['Item ARK', ['Collection', 'Work', 'ChildWork', 'Manuscript', 'Page']],
  ['Title', ['Collection', 'Work', 'Manuscript']],
  ['IIIF Manifest URL', ['Collection', 'Work']],
  # ['Object Type', ['Collection', 'Work']],  # hard-coded
  ['Parent ARK', ['Work', 'ChildWork', 'Manuscript', 'Page']],
  ['Rights.copyrightStatus', ['Work', 'ChildWork', 'Manuscript', 'Page']],
  ['File Name', ['Work', 'ChildWork', 'Page']]
].freeze

MAPPED_HEADERS = CalifornicaMapper.californica_terms_map.values.map { |v| Array.wrap(v) }.flatten.freeze

# Headers that aren't in the map, but that we shouldn't complain about.
# Some have structural info, others are used e.g. in Sinai but not (yet) imported to Californica
OTHER_OPTIONAL_HEADERS = [
  "Description.contents",
  "Description.illustrations",
  "featured_image",
  "Item Sequence",
  "Object Type",
  "Parent ARK",
  "Project Name",
  "representative_image",
  "Rights.statementLocal",
  "Scribe",
  "tagline",
  "Visibility"
].freeze

OPTIONAL_HEADERS = MAPPED_HEADERS + OTHER_OPTIONAL_HEADERS - REQUIRED_HEADERS

CONTROLLED_VOCABULARIES = {
  'Language' => Qa::Authorities::Local.subauthority_for('languages').all.map { |x| x['id'] },
  'License' => Qa::Authorities::Local.subauthority_for('licenses').all.map { |x| x['label'] },
  'Rights.copyrightStatus' => Qa::Authorities::Local.subauthority_for('rights_statements').all.map { |x| x['label'] },
  'Type.typeOfResource' => Qa::Authorities::Local.subauthority_for('resource_types').all.map { |x| x['label'] },
  'IIIF Text direction' => Qa::Authorities::Local.subauthority_for('iiif_text_directions').all.map { |x| x['label'] }
}.freeze

N_ROWS_TO_WARN = 5 # use Float::INFINITY to show all row numbers in warnings

class CsvManifestValidator
  # @param manifest_uploader [CsvManifestUploader] The manifest that's mounted to a CsvImport record.  See carrierwave gem documentation.  This is basically a wrapper for the CSV file.
  def initialize(manifest_uploader)
    @csv_file = manifest_uploader.file
    @file_uri_base_path = ENV['IMPORT_FILE_PATH']
    @errors = []
    @warnings = []
    @mapper = CalifornicaMapper.new

    # This is a hack bc WorkIndexer is supposed to be initialized with a Hyrax object, not a Mapper. It works for now bc both support the 'normalized_date' method, which is all we're initially using, but be very careful about using it for anything else.
    @indexer = WorkIndexer.new(@mapper)
  end

  # Errors and warnings for the CSV file.
  attr_reader :errors, :warnings
  attr_reader :csv_file, :file_uri_base_path

  def validate
    @rows = CSV.read(csv_file.path, headers: true)
    @headers = @rows.headers || []
    # TODO: follow transformed_headers breadcrumb to make case-insensitive
    # @transformed_headers = @headers.map { |header| header.downcase.strip }

    missing_headers
    duplicate_headers
    unrecognized_headers
    validate_records
  rescue => e
    @errors << "#{e.class}: #{e.message}"
  end

  # One record per row
  def record_count
    return nil unless @rows
    @rows.size
  end

  def valid_headers
    REQUIRED_HEADERS + OPTIONAL_HEADERS
  end

private

  def missing_headers
    REQUIRED_HEADERS.each do |required_header|
      next if @headers.include?(required_header)
      @errors << "Missing required column: #{required_header}.  Your spreadsheet must have this column.  If you already have this column, please check the spelling and capitalization."
    end
  end

  # Warn the user if we find any unexpected headers.
  def unrecognized_headers
    extra_headers = @headers - valid_headers
    skip_headers = ['Item Status ID', 'Item Status', 'Duplicate', 'Delete in Title']
    extra_headers = extra_headers.reject do |header|
      skip_headers.include?(header)
    end
    extra_headers.each do |header|
      @warnings << "The field name \"#{header}\" is not supported.  This field will be ignored, and the metadata for this field will not be imported."
    end
    extra_headers
  end

  def duplicate_headers
    @headers.group_by { |header| header }.each do |header, copies|
      @errors << "Duplicate column header: #{header} (used #{copies.length} times). Each column must have a unique header." if copies.length > 1
    end
  end

  def validate_records
    required_column_numbers = REQUIRED_VALUES.map { |header, _object_types| @headers.find_index(header) }.compact
    controlled_column_numbers = CONTROLLED_VOCABULARIES.keys.map { |header| @headers.find_index(header) }.compact
    object_type_column = @headers.find_index('Object Type')
    row_warnings = Hash.new { |hash, key| hash[key] = [] }
    row_errors = Hash.new { |hash, key| hash[key] = [] }

    @rows.each_with_index do |row, i|
      @mapper.metadata = row
      this_row_warnings = []
      this_row_errors = []

      # Investigate Error warning: Row 1881, 1882, 1883, 1884, 1885, ...: Rows missing "Parent ARK" cannot be imported.
      # required_column_numbers_2 = []
      # REQUIRED_VALUES.each do |header, _object_types|
      # this_row_warnings << "#{header} is at column number  #{@headers.find_index(header)}"
      # required_column_numbers_2.push(@headers.find_index(header))
      # end

      # If there's no "Object Type" header, assume everything's a Work
      # so we so we can validate other required fields
      object_type = object_type_column ? row[object_type_column] : 'Work'

      # Row has no "Object Type"
      if object_type.blank?
        this_row_warnings << "Rows missing \"Object Type\" cannot be imported."
        object_type = 'Work' # so we can validate other required fields
      end

      # Row has invalid "Object Type"
      unless object_type.blank? || OBJECT_TYPES.include?(object_type)
        this_row_warnings << "Rows with invalid Object Type \"#{object_type}\" cannot be imported."
        object_type = 'Work' # so we can validate other required fields
      end

      # Row missing reqired field values
      required_column_numbers.each_with_index do |column_number, j|
        field_label, types_that_require = REQUIRED_VALUES[j]
        next this_row_errors << "Rows missing required value for \"#{REQUIRED_VALUES[j][0]}\".  Your spreadsheet must have this value." if field_label == 'Title' && row[column_number].blank?
        next this_row_errors << "Rows missing required value for \"#{REQUIRED_VALUES[j][0]}\".  Your spreadsheet must have this value." if field_label == 'Item ARK' && row[column_number].blank?
        next this_row_errors << "Rows missing required value for \"#{REQUIRED_VALUES[j][0]}\".  Your spreadsheet must have this value." if field_label == 'IIIF Manifest URL' && !object_type.include?("Page") && row[column_number].blank?
        next unless types_that_require.include?(object_type)
        next unless row[column_number].blank?
        this_row_warnings << if field_label == 'Rights.copyrightStatus'
                               'Rows missing "Rights.copyrightStatus" will have the value set to "unknown".'
                             elsif field_label == 'File Name'
                               'Rows missing "File Name" will import metadata-only.'
                             elsif field_label != 'Title' || field_label != 'Item ARK' || field_label != 'IIIF Manifest URL'
                               "Rows missing \"#{REQUIRED_VALUES[j][0]}\" cannot be imported." # Debug details #{REQUIRED_VALUES.map { |header, _object_types| header }} #{required_column_numbers}
                             end
      end

      # Row has invalid value in a controlled-vocabulary field
      controlled_column_numbers.each do |column_number|
        field_name = @headers[column_number]
        allowed_values = CONTROLLED_VOCABULARIES[field_name]
        row[column_number].to_s.split('|~|').each do |this_value|
          this_row_warnings << "'#{this_value}' is not a valid value for '#{field_name}'" unless allowed_values.include?(this_value)
        end
      end

      # Row has a File Name that doesn't exist
      if @mapper.preservation_copy
        if @mapper.preservation_copy.start_with?('masters.in.library.ucla.edu/')
          full_path = File.join(file_uri_base_path, 'Masters', @mapper.preservation_copy.sub(/^masters.in.library.ucla.edu\//, ''))
          this_row_warnings << "Rows contain a File Name that does not exist. Incorrect values may be imported." unless File.exist?(full_path)
        else
          this_row_warnings << "Unable to check that file exists. Only files in masters.in.library.ucla.edu/ can be checked at this time." unless File.exist?(full_path)
        end
      end

      # Row has improperly formatted date values
      unless @mapper.normalized_date.to_a.empty?
        dates = @mapper.normalized_date.to_a[0].split('/')

        # this_row_warnings << "Normalized date is '#{dates}'"
        # this_row_warnings << "Indexer date is '#{@indexer.solr_dates}'"

        this_row_warnings << "Rows contain unparsable values for 'normalized_date'." if dates.length != @indexer.solr_dates.to_a.length
      end

      this_row_warnings.each do |warning|
        # +1 for 0-based indexing, +1 for skipped headers
        row_warnings[warning] << i + 2
      end

      this_row_errors.each do |row_error|
        # +1 for 0-based indexing, +1 for skipped headers
        row_errors[row_error] << i + 2
      end
    end

    row_warnings.each do |warning, rows|
      rows = rows[0, N_ROWS_TO_WARN] + ['...'] if rows.length > N_ROWS_TO_WARN
      @warnings << "Row #{rows.join(', ')}: #{warning}"
    end

    row_errors.each do |row_error, rows|
      rows = rows[0, N_ROWS_TO_WARN] + ['...'] if rows.length > N_ROWS_TO_WARN
      @errors << "Row #{rows.join(', ')}: #{row_error}"
    end
  end
end
