# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvManifestValidator, type: :model do
  let(:validator) { described_class.new(manifest) }
  let(:manifest) { csv_import.manifest }
  let(:user) { FactoryBot.build(:user) }
  let(:csv_file) { File.join(fixture_path, 'csv_import', 'import_manifest.csv') }
  let(:csv_import) do
    import = CsvImport.new(user: user, import_file_path: fixture_path)
    File.open(csv_file) { |f| import.manifest = f }
    import
  end

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('IMPORT_FILE_PATH').and_return(fixture_path)

    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with(File.join(ENV['IMPORT_FILE_PATH'], 'Masters/dlmasters/clusc_1_1_00010432a.tif')).and_return(true)
  end

  context 'a valid CSV file' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'import_manifest.csv') }

    it 'has no errors' do
      expect(validator.errors).to eq []
    end

    it 'has no warnings' do
      expect(validator.warnings).to eq []
    end

    it 'returns the record count' do
      validator.validate
      expect(validator.record_count).to eq 3
    end
  end

  context 'a file that can\'t be parsed' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'import_manifest.csv') }

    it 'has an error' do
      allow(CSV).to receive(:read).and_raise(CSV::MalformedCSVError, 'abcdefg')
      validator.validate
      expect(validator.errors).to contain_exactly(
        "CSV::MalformedCSVError: abcdefg"
      )
    end
  end

  context 'a CSV that is missing required headers' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'missing_title_header.csv') }

    it 'has an error' do
      missing_title_error = 'Missing required column: Title.  Your spreadsheet must have this column.  If you already have this column, please check the spelling and capitalization.'
      validator.validate
      expect(validator.errors).to contain_exactly(missing_title_error)
    end
  end

  context 'a CSV with duplicate headers' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'duplicate_headers.csv') }

    it 'has an error' do
      validator.validate
      expect(validator.errors).to contain_exactly(
        'Duplicate column header: Title (used 2 times). Each column must have a unique header.'
      )
    end
  end

  context 'a CSV that is missing required/recommended values' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'missing_values.csv') }

    it 'has warnings and errors' do
      validator.validate
      expect(validator.errors).to contain_exactly(
        'Row 3: Rows missing required value for "Item ARK".  Your spreadsheet must have this value.',
        'Row 4: Rows missing required value for "Title".  Your spreadsheet must have this value.',
        'Row 4, 5, 6, 7, 8: Rows missing required value for "IIIF Manifest URL".  Your spreadsheet must have this value.'
      )
      expect(validator.warnings).to contain_exactly(
        'Row 5: Rows missing "Object Type" cannot be imported.',
        'Row 6: Rows missing recommended value for "Parent ARK". Please add this value or continue to import without.',
        'Row 7: Rows missing recommended value for "Rights.copyrightStatus". Please add this value or continue to import without.',
        'Row 8: Rows missing recommended value for "File Name". Please add this value or continue to import without.',
        'Row 9: Rows missing recommended value for "Thumbnail". Please add this value or continue to import without.'
      )
    end
  end

  context 'a CSV that has extra headers' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'extra_headers.csv') }

    it 'has a warning' do
      validator.validate
      expect(validator.warnings).to include(
        'The field name "another_header_1" is not supported.  This field will be ignored, and the metadata for this field will not be imported.',
        'The field name "another_header_2" is not supported.  This field will be ignored, and the metadata for this field will not be imported.'
      )
    end
  end

  context 'a CSV with invalid values in controlled-vocabulary fields' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'invalid_values.csv') }

    it 'has warnings' do
      validator.validate
      expect(validator.warnings).to include(
        'Row 2: \'invalid rights statement\' is not a valid value for \'Rights.copyrightStatus\'',
        'Row 3, 4: \'invalid type\' is not a valid value for \'Type.typeOfResource\'',
        'Row 5: Rows with invalid Object Type "InvalidWork" cannot be imported.'
      )
    end
  end

  context 'when the csv has a missing file' do
    let(:csv_file) { 'spec/fixtures/example-missingimage.csv' }
    let(:path) { File.join(ENV['IMPORT_FILE_PATH'], 'Masters/dlmasters/missing_file.tif') }
    let(:warning_text) { "Row 2: Rows contain a File Name that does not exist. Incorrect values may be imported." }

    it 'has warnings' do
      allow(File).to receive(:exist?).with(path).and_return(false)
      validator.validate
      expect(validator.warnings).to include(warning_text)
    end

    it 'doesn\'t warn about files that aren\'t missing' do
      allow(File).to receive(:exist?).with(path).and_return(true)
      validator.validate
      expect(validator.warnings).to_not include(warning_text)
    end
  end

  context 'when the csv has improperly formatted dates' do
    let(:csv_file) { 'spec/fixtures/example-baddates.csv' }

    it 'warns about the bad dates, not about the good' do
      validator.validate
      expect(validator.warnings).to contain_exactly("Row 2: Rows contain unparsable values for 'normalized_date'.")
    end
  end

  context 'when the csv has an \'ingest.iiif\' URL' do
    let(:csv_file) { File.join(fixture_path, 'csv_import', 'csv_files_with_problems', 'example-ingest_dot_iiif_url.csv') }

    it 'gives a warning' do
      validator.validate
      expect(validator.warnings).to contain_exactly("Row 2: 'IIIF Manifest URL' points to ingest.iiif.library.ucla.edu.")
    end
  end

  describe '#valid_headers' do
    it 'Contains all the values from CalifornicaMapper.CALIFORNICA_TERMS_MAP' do
      expect(validator.valid_headers).to contain_exactly(
        "access_copy",
        "AdminNote",
        "Alt ID.local",
        "Alt ID.url",
        "Alternate Identifier.local",
        "Alternate Title.creator",
        "Alternate Title.descriptive",
        "Alternate Title.inscribed",
        "Alternate Title.other",
        "AltIdentifier.callNo",
        "AltIdentifier.local",
        "AltTitle.descriptive",
        "AltTitle.other",
        "AltTitle.parallel",
        "AltTitle.translated",
        "AltTitle.uniform",
        "Author",
        "Binding note",
        "Calligrapher",
        "Collation",
        "Colophon",
        "Commentator",
        "Condition note",
        "Contents note",
        "Coverage.geographic",
        "Creator",
        "Date.created",
        "Date.creation",
        "Date.normalized",
        "Description.abstract",
        "Description.adminnote",
        "Description.binding",
        "Description.caption",
        "Description.colophon",
        "Description.condition",
        "Description.contents",
        "Description.fundingNote",
        "Description.history",
        "Description.illustrations",
        "Description.illustrations",
        "Description.latitude",
        "Description.longitude",
        "Description.note",
        "Description.opac",
        "Description.tableOfContents",
        "Editor",
        "Engraver",
        "Featured image",
        "featured_image",
        "File Name",
        "Finding Aid URL",
        "Foliation note",
        "Foliation",
        "Format",
        "Format.dimensions",
        "Format.extent",
        "Format.medium",
        "Genre",
        "Identifier",
        "IIIF Access URL",
        "IIIF Manifest URL",
        "IIIF Range",
        "Illuminator",
        "Illustrations note",
        "Illustrator",
        "Item ARK",
        "Item Sequence",
        "Language",
        "Local identifier",
        "Masthead",
        "Name.architect",
        "Name.calligrapher",
        "Name.editor",
        "Name.engraver",
        "Name.commentator",
        "Name.composer",
        "Name.creator",
        "Name.illuminator",
        "Name.illustrator",
        "Name.lyricist",
        "Name.printmaker",
        "Name.photographer",
        "Name.repository",
        "Name.rubricator",
        "Name.scribe",
        "Name.subject",
        "Name.translator",
        "Note",
        "Note.admin",
        "Object Type",
        "Opac url",
        "oai_set",
        "Page layout",
        "Parent ARK",
        "Personal or Corporate Name.copyrightHolder",
        "Personal or Corporate Name.photographer",
        "Personal or Corporate Name.repository",
        "Personal or Corporate Name.subject",
        "Place of origin",
        "Printmaker",
        "Project Name",
        "Program",
        "Provenance",
        "Publisher.placeOfOrigin",
        "Publisher.publisherName",
        "Relation.isPartOf",
        "repository",
        "References",
        "Repository",
        "Representative image",
        "representative_image",
        "Rights.copyrightStatus",
        "Rights.countryCreation",
        "Rights.rightsHolderContact",
        "Rights.rightsHolderName",
        "Rights.servicesContact",
        "Rights.statementLocal",
        "Rubricator",
        "Scribe",
        "Statement of Responsibility",
        "Subject geographic",
        "Subject.culturalObject",
        "Subject.culturalObject", # this for subject topic
        "Subject.domainTopic",
        "Subject.domainTopic", # this for subject topic
        "Subject name",
        "Subject place",
        "Subject temporal",
        "Subject topic",
        "Subject.conceptTopic",
        "Subject.corporateName",
        "Subject.descriptiveTopic",
        "Subject.personalName",
        "Subject",
        "Summary",
        "Support",
        "Table of Contents",
        "tagline",
        "Tagline",
        "Text direction",
        "Thumbnail",
        "Title",
        "Translator",
        "Type.genre",
        "Type.typeOfResource",
        "viewingHint",
        "Visibility",
        "License",
        "Artist",
        "Name.artist",
        "Cartographer",
        "Name.cartographer",
        "Content disclaimer",
        "Director",
        "Name.director",
        "Interviewer",
        "Name.interviewer",
        "Interviewee",
        "Name.interviewee",
        "Producer",
        "Name.producer",
        "Recipient",
        "Name.recipient",
        "Related Items",
        "Series",
        "Host",
        "Name.host",
        "Musician",
        "Name.musician",
        "Printer",
        "Name.printer",
        "Researcher",
        "Name.researcher",
        # adds these twice because they are also part of named_subject
        "Host",
        "Name.host",
        "Musician",
        "Name.musician",
        "Printer",
        "Name.printer",
        "Researcher",
        "Name.researcher",
        "Rights.statementLocal",
        "Related Records",
        "Edition",
        "History",
        "External item record",
        "View Record"
      )
    end
  end
end
