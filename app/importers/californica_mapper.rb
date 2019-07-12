# frozen_string_literal: true

class CalifornicaMapper < Darlingtonia::HashMapper
  attr_reader :missing_file_log, :import_file_path, :row_number

  CALIFORNICA_TERMS_MAP = {
    alternative_title: ["AltTitle.other",
                        "AltTitle.parallel",
                        "AltTitle.translated",
                        "Alternate Title.creator",
                        "Alternate Title.descriptive",
                        "Alternate Title.inscribed",
                        "Alternate Title.other"],
    architect: "Name.architect",
    ark: "Item ARK",
    caption: "Description.caption",
    date_created: "Date.creation",
    description: "Description.note",
    dimensions: "Format.dimensions",
    dlcs_collection_name: "Relation.isPartOf",
    extent: "Format.extent",
    funding_note: "Description.fundingNote",
    genre: "Type.genre",
    language: "Language",
    latitude: "Description.latitude",
    local_identifier: ["Alternate Identifier.local",
                       "AltIdentifier.callNo",
                       "AltIdentifier.local",
                       "Alt ID.local"],
    location: "Coverage.geographic",
    longitude: "Description.longitude",
    master_file_path: "File Name",
    medium: "Format.medium",
    named_subject: ["Name.subject",
                    "Personal or Corporate Name.subject",
                    "Subject.corporateName",
                    "Subject.personalName"],
    normalized_date: "Date.normalized",
    photographer: ["Name.photographer",
                   "Personal or Corporate Name.photographer"],
    place_of_origin: "Place of origin",
    publisher: "Publisher.publisherName",
    repository: ["Name.repository",
                 "Personal or Corporate Name.repository"],
    resource_type: "Type.typeOfResource",
    rights_country: "Rights.countryCreation",
    rights_holder: ["Personal or Corporate Name.copyrightHolder",
                    "Rights.rightsHolderContact"],
    rights_statement: "Rights.copyrightStatus",
    services_contact: "Rights.servicesContact",
    subject: "Subject",
    support: "Support",
    title: "Title",
    uniform_title: "AltTitle.uniform"
  }.freeze

  DELIMITER = '|~|'

  def initialize(attributes = {})
    @missing_file_log = ENV['MISSING_FILE_LOG'] || "#{::Rails.root}/log/missing_files_#{Rails.env}"
    @import_file_path = attributes[:import_file_path] || ENV['IMPORT_FILE_PATH'] || '/opt/data'
    @row_number = attributes[:row_number]
    super()
  end

  # What columns are allowed in the CSV
  def self.allowed_headers
    CALIFORNICA_TERMS_MAP.values +
      ['File Name', 'Parent ARK', 'Project Name', 'Object Type', 'Item Sequence', 'Visibility']
  end

  # What columns must exist in the CSV
  def self.required_headers
    ['Title', 'Item ARK']
  end

  def fields
    # The fields common to all object types
    common_fields = CALIFORNICA_TERMS_MAP.keys + [:remote_files, :visibility, :member_of_collections_attributes, :license]
    # Pages additionally have a field :in_works_ids, which defines their parent work
    return common_fields + [:in_works_ids] if ['ChildWork', 'Page'].include?(metadata["Object Type"])
    common_fields
  end

  def object_type
    metadata['Object Type']
  end

  def collection?
    object_type&.downcase&.chomp == 'collection'
  end

  ##
  # Take a filename and:
  # 1) Check that it exists. Log it to a missing files log if it doesn't.
  # 2) Turn the filename into a file:// url
  # 3) Pass it to the actor stack in the remote_files param. This means that
  # it will be processed by the CreateWithRemoteFilesActor
  # Using the remote_files param to ingest local files is misleading.
  # However, it lets us fetch the file from disk in a background job
  # instead of creating a Hyrax::UploadedFile object while the CSV is
  # being parsed, which gives us a performance advantage.
  def remote_files
    return [] if collection?
    if metadata['File Name'].nil?
      File.open(@missing_file_log, 'a') { |file| file.puts "Work #{ark} is missing a filename" }
      return []
    end
    file_name = file_uri_base_path.join(metadata['File Name']).to_s
    file_exists = File.exist?(file_name)
    return_value = []
    if file_exists
      return_value = [{ url: file_uri_for(name: metadata['File Name']) }]
    else
      File.open(@missing_file_log, 'a') { |file| file.puts "Work #{ark} has an invalid file: #{file_name} not found" }
    end
    return_value
  end

  def visibility
    value_from_csv = metadata['Visibility']&.squish&.downcase
    visibility_mapping.fetch(value_from_csv, Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC)
  end

  # The visibility values have different values when
  # they are calculated or indexed in solr than the
  # values that appear in the UI edit form.  We should
  # accept both.
  def visibility_mapping
    {
      'private' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE,
      'restricted' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE,
      'discovery' => ::Work::VISIBILITY_TEXT_VALUE_DISCOVERY,
      'authenticated' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
      'registered' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
      'ucla' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
      'open' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
      'public' => Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    }.freeze
  end

  def ark
    Ark.ensure_prefix(map_field(:ark).to_a.first)
  end

  # Replace marc codes with double dashes with no surrounding spaces
  def architect
    map_field(:architect)&.map { |a| a.gsub(/ \$[a-z] /, ' ') }
  end

  # To avoid having to normalize data before import,
  # if the collection is LADNN, hard-code the extent. (Story #111)
  def extent
    if ladnn?
      ['1 photograph']
    else
      map_field(:extent)
    end
  end

  # License is applied at import time, and only for specific collections
  def license
    return nil unless ladnn?
    ["https://creativecommons.org/licenses/by/4.0/"]
  end

  # Replace marc codes with double dashes with no surrounding spaces
  def photographer
    map_field(:photographer)&.map { |a| a.gsub(/ \$[a-z] /, ' ') }
  end

  # Hard-code repository for LADNN collection. Story #121
  def repository
    if ladnn?
      ['University of California, Los Angeles. Library. Department of Special Collections']
    else
      # Replace marc codes with double dashes and no surrounding spaces
      map_field(:repository)&.map { |a| a.gsub(/ \$[a-z] /, ' ') }
    end
  end

  # Normalize subject to remove MaRC codes (e.g., $z separators)
  # Replace subject marc codes with double dashes with no surrounding spaces
  def subject
    map_field(:subject)&.map { |a| a.gsub(/ \$[a-z] /, '--') }
  end

  # Normalize named subject to remove MaRC codes (e.g., $d separators)
  # Replace named subject marc codes and their surrounding spaces with a single space
  def named_subject
    map_field(:named_subject)&.map { |a| a.gsub(/ \$[a-z] /, ' ') }
  end

  # Hard-code language for LADNN collection. Story #48
  def language
    if ladnn?
      ['zxx'] # MARC code for 'No linguistic content'
    else
      # If it's populated, DLCS uses MARC IDs, not labels, so we don't need to map like w/ resource_type
      map_field(:language)
    end
  end

  def ladnn?
    metadata['Project Name'] == 'Los Angeles Daily News Negatives'
  end

  def master_file_path
    path = map_field(:master_file_path).first.to_s.strip.sub(/^\//, '')
    return nil if path.empty?
    if path.start_with?('Masters/')
      path
    else
      'Masters/dlmasters/' + path
    end
  end

  def resource_type
    map_field(:resource_type).to_a.map do |label|
      term = Qa::Authorities::Local.subauthority_for('resource_types').all.find { |h| h[:label] == label }
      term.blank? ? nil : term[:id]
    end.compact
  end

  # The CSV file contains the label, so we'll find the
  # corresponding ID to store on the work record.
  # If the term isn't found in
  # config/authorities/rights_statements.yml
  # just return the value from the CSV file.  If it is
  # not a valid value, it will eventually be rejected
  # by the RightsStatementValidator.
  def rights_statement
    authority = Qa::Authorities::Local.subauthority_for('rights_statements')
    rights_statement = map_field(:rights_statement).to_a.map do |label|
      label = { 'pd' => 'public domain' }[label] || label # these values need to be mapped
      term = authority.all.find { |h| h[:label] == label }
      term.blank? ? label : term[:id]
    end
    rights_statement << authority.all.find { |h| h[:label] == 'unknown' }[:id] if rights_statement.empty?
    rights_statement
  end

  def map_field(name)
    return unless CALIFORNICA_TERMS_MAP.keys.include?(name)

    Array.wrap(CALIFORNICA_TERMS_MAP[name]).map do |source_field|
      metadata[source_field]&.split(DELIMITER)
    end.flatten.compact
  end

  # Determine what Collection this object should be part of.
  # Ensure that Collection object exists.
  # Assume the parent of this object is a collection unless the Object Type is ChildWork
  def member_of_collections_attributes
    # A ChildWork will never be a direct member of a Collection
    return if ['ChildWork', 'Page'].include?(metadata["Object Type"])
    ark = Ark.ensure_prefix(metadata['Parent ARK'])
    return unless ark
    collection = Collection.find_or_create_by_ark(ark)
    { '0' => { id: collection.id } }
  end

  def sequence
    metadata['Item Sequence']
  end

  def parent_ark
    Ark.ensure_prefix(metadata['Parent ARK'])
  end

  # Record the page sequence in the database so it's quick to access and sort.
  # At the end of an import for a multi-page work, we'll use these to order the ChildWorks.
  def record_page_sequence
    PageOrder.find_by(child: ark)&.destroy
    PageOrder.create(parent: parent_ark, child: ark, sequence: sequence)
  end

  def parent_work
    Work.find_or_create_by_ark(parent_ark)
  end

  def in_works_ids
    return unless ['ChildWork', 'Page'].include?(metadata["Object Type"])
    record_page_sequence
    [parent_work.id]
  end

  private

    def file_uri_for(name:)
      uri      = URI('file:///')
      uri.path = file_uri_base_path.join(name).to_s
      uri.to_s
    end

    # Prefer the import_file_path that's been explicitly passed to this instance of CalifornicaMapper
    # if it exists.
    def file_uri_base_path
      Pathname.new(@import_file_path)
    end
end
