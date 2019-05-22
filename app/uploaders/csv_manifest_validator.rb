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

OBJECT_TYPES = ['Collection', 'Work', 'Manuscript', 'Page'].freeze

REQUIRED_HEADERS = [
  'Item Ark',
  'Title',
  'Object Type',
  'Parent ARK',
  'Rights.copyrightStatus',
  'File Name'
].freeze

REQUIRED_VALUES = [
  ['Item Ark', ['Collection', 'Work']],
  ['Title', ['Collection', 'Work']],
  # ['Object Type', ['Collection', 'Work']],  # hard-coded
  ['Parent ARK', ['Work']],
  ['Rights.copyrightStatus', ['Work']],
  ['File Name', ['Work']]
].freeze

OPTIONAL_HEADERS = [
  'AltIdentifier.local',
  'Coverage.geographic',
  'Date.creation',
  'Date.normalized',
  'Description.caption',
  'Description.fundingNote',
  'Description.latitude',
  'Description.longitude',
  'Description.note',
  'Format.dimensions',
  'Format.extent',
  'Format.medium',
  'Item Sequence',
  'Language',
  'Name.architect',
  'Name.photographer',
  'Name.repository',
  'Name.subject',
  'Project Name',
  'Publisher.publisherName',
  'Relation.isPartOf',
  'Rights.countryCreation',
  'Rights.rightsHolderContact',
  'Rights.servicesContact',
  'Subject',
  'Type.genre',
  'Type.typeOfResource'
].freeze

CONTROLLED_VOCABULARIES = {
  'Language' => Qa::Authorities::Local.subauthority_for('languages').all.map { |x| x['id'] },
  'License' => Qa::Authorities::Local.subauthority_for('licenses').all.map { |x| x['label'] },
  'Rights.copyrightStatus' => Qa::Authorities::Local.subauthority_for('rights_statements').all.map { |x| x['label'] },
  'Type.typeOfResource' => Qa::Authorities::Local.subauthority_for('resource_types').all.map { |x| x['label'] }
}.freeze

N_ROWS_TO_WARN = 5 # use Float::INFINITY to show all row numbers in warnings

class CsvManifestValidator
  # @param manifest_uploader [CsvManifestUploader] The manifest that's mounted to a CsvImport record.  See carrierwave gem documentation.  This is basically a wrapper for the CSV file.
  def initialize(manifest_uploader)
    @csv_file = manifest_uploader.file
    @errors = []
    @warnings = []
  end

  # Errors and warnings for the CSV file.
  attr_reader :errors, :warnings
  attr_reader :csv_file

  def validate
    @rows = CSV.read(csv_file.path)
    @headers = @rows.first || []
    # TODO: follow transformed_headers breadcrumb to make case-insensitive
    # @transformed_headers = @headers.map { |header| header.downcase.strip }

    missing_headers
    unrecognized_headers
    validate_records
  end

  # One record per row
  def record_count
    return nil unless @rows
    @rows.size - 1 # Don't include the header row
  end

  def valid_headers
    REQUIRED_HEADERS + OPTIONAL_HEADERS
  end

private

  def missing_headers
    REQUIRED_HEADERS.each do |required_header|
      missing_required_header?(@rows.first, required_header)
    end
  end

  def missing_required_header?(row, header)
    return if row.include?(header)
    @errors << "Missing required column: #{header}.  Your spreadsheet must have this column.  If you already have this column, please check the spelling and capitalization."
  end

  # Warn the user if we find any unexpected headers.
  def unrecognized_headers
    extra_headers = @rows.first - valid_headers
    extra_headers.each do |header|
      @warnings << "The field name \"#{header}\" is not supported.  This field will be ignored, and the metadata for this field will not be imported."
    end
    extra_headers
  end

  def validate_records
    required_column_numbers = REQUIRED_VALUES.map { |header, _object_types| @headers.find_index(header) }.compact
    controlled_column_numbers = CONTROLLED_VOCABULARIES.keys.map { |header| @headers.find_index(header) }.compact
    object_type_column = @headers.find_index('Object Type')
    row_warnings = Hash.new { |hash, key| hash[key] = [] }

    @rows.each_with_index do |row, i|
      # Skip header row
      next if i.zero?

      # Row has the wrong number of columns
      if row.length != @headers.length
        @warnings << "Can't import Row #{i + 1}: expected #{@headers.length} columns, got #{row.length}."
        next
      end

      # If there's no "Object Type" header, assume everything's a Work
      # so we so we can validate other required fields
      object_type = object_type_column ? row[object_type_column] : 'Work'

      # Row has no "Object Type"
      if object_type.blank?
        @warnings << "Can't import Row #{i + 1}: missing \"Object Type\"."
        object_type = 'Work' # so we can validate other required fields
      end

      # Row has invalid "Object Type"
      unless OBJECT_TYPES.include?(object_type)
        @warnings << "Can't import Row #{i + 1}: invalid \"Object Type\"."
        object_type = 'Work' # so we can validate other required fields
      end

      # Row missing reqired field values
      required_column_numbers.each_with_index do |column_number, j|
        field_label, types_that_require = REQUIRED_VALUES[j]
        next unless types_that_require.include?(object_type)
        next unless row[column_number].blank?
        @warnings << if field_label == 'Rights.copyrightStatus'
                       "Row #{i + 1}: missing 'Rights.copyrightStatus' will be set to 'unknown'."
                     else
                       "Can't import Row #{i + 1}: missing \"#{REQUIRED_VALUES[j][0]}\"."
                     end
      end

      # Row has invalid value in a controlled-vocabulary field
      controlled_column_numbers.each do |column_number|
        field_name = @headers[column_number]
        allowed_values = CONTROLLED_VOCABULARIES[field_name]
        row[column_number].to_s.split('|~|').each do |this_value|
          unless allowed_values.include?(this_value)
            message = "'#{this_value}' is not a valid value for '#{field_name}'"
            row_warnings[message] << i + 1
          end
        end
      end
    end

    row_warnings.each do |warning, rows|
      rows = rows[0, N_ROWS_TO_WARN] + ['...'] if rows.length > N_ROWS_TO_WARN
      @warnings << "Row #{rows.join(', ')}: #{warning}"
    end
  end
end
