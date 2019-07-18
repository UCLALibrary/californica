# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaMapper do
  subject(:mapper) { described_class.new(import_file_path: fixture_path) }

  let(:metadata) do
    { "AltTitle.other" => "alternative title", # alternative_title
      "AltTitle.translated" => "translated alternative title", # alternative_title
      "AltTitle.parallel" => "parallel alternative title", # alternative_title
      "Alternate Title.creator" => "alternative title creator", # alternative_title
      "Alternate Title.descriptive" => "descriptive alternative title", # alternative_title
      "Alternate Title.inscribed" => "alternative title inscribed", # alternative_title
      "Alternate Title.other" => "alternative title other", # alternative_title
      "Author" => "author", # author
      "Name.architect" => "Imhotep", # architect
      "Item ARK" => "ark:/21198/zz0002nq4w", # ark
      "Description.caption" => "This example does not have a caption.", # caption
      "Date.creation" => "July 4th 1947", # date_created
      "Description.note" => "Protesters with signs", # description
      "Format.dimensions" => "8 inches by 12 inches", # dimensions
      "Relation.isPartOf" => "Connell (Will) Papers, 1928-1961", # lcs_collection_named
      "Format.extent" => "1 photograph", # extent
      "Description.fundingNote" => "Funded by LA County", # funding_note
      "Type.genre" => "Journalism", # genre
      "Language" => "eng", # language
      "Description.latitude" => "34.052235", # latitude
      "AltIdentifier.local" => "UCLA-1234a", # local_identifier
      "Alternate Identifier.local" => "UCLA-1234b", # local_identifier
      "AltIdentifier.callNo" => "UCLA-1234c", # local_identifier
      "Alt ID.local" => "UCLA-1234d", # local_identifier
      "Coverage.geographic" => "Los Angeles (Calif.)", # location
      "Description.longitude" => "-118.243683", # longitude
      "File Name" => "clusc_1_1_00010432a.tif", # master_file_path
      "Format.medium" => "photograph", # medium
      "Name.subject" => "Los Angeles County (Calif.). $b Board of Supervisors", # named_subject
      "Personal or Corporate Name.subject" => "LA County", # named_subject
      "Subject.personalName" => "Alan Smithee", # named_subject
      "Subject.corporateName" => "The Corporation", # named_subject
      "Date.normalized" => "July 4th 1947", # normalized_date
      "Name.photographer" => "Unknown", # photographer
      "Personal or Corporate Name.photographer" => "Unknown", # photographer
      "Place of origin" => 'Los Angeles, CA', # place_of_origin
      "Publisher.publisherName" => "Los Angeles Daily News", # publisher
      "Name.repository" => "University of California, Los Angeles. $b Library Special Collections", # repository
      "Personal or Corporate Name.repository" => "Personal || Corporate Repo", # repository
      "Type.typeOfResource" => "still image|~|acetate film", # resource_type
      "Rights.countryCreation" => "US", # rights_country
      "Rights.rightsHolderContact" => "UCLA", # rights_holder
      "Personal or Corporate Name.copyrightHolder" => "UCLA", # rights_holder
      "Rights.copyrightStatus" => "Public Domain", # rights_statement
      "Rights.servicesContact" => "UCLA", # services_contact
      "Subject" => "Express highways--California--Los Angeles County--Design and construction|~|" \
        "Eminent domain--California--Los Angeles|~|Demonstrations--California--Los Angeles County|~|" \
        "Transportation|~|Government|~|Activism|~|Interstate 10", # subject
      "Support" => "Support", # support
      "Title" => "Protesters with signs in gallery of Los Angeles County Supervisors " \
        "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947", # title
      "AltTitle.uniform" => "Protesters with signs in gallery of Los Angeles County Supervisors" } # uniform_title
  end

  before { mapper.metadata = metadata }
  after { File.delete(ENV['MISSING_FILE_LOG']) if File.exist?(ENV['MISSING_FILE_LOG']) }

  it "maps resource type to local authority values, if possible" do
    expect(mapper.resource_type).to contain_exactly(
      'http://id.loc.gov/vocabulary/resourceTypes/img'
    )
  end

  it "maps the required title field" do
    expect(mapper.map_field(:title))
      .to contain_exactly("Protesters with signs in gallery of Los Angeles County Supervisors " \
                          "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947")
  end

  it "maps the collection (relation.isPartOf) field" do
    expect(mapper.map_field(:dlcs_collection_name)).to contain_exactly("Connell (Will) Papers, 1928-1961")
  end

  context 'with a blank filename' do
    let(:metadata) do
      { "Item ARK" => "21198/zz0002nq4w",
        "Title" => "Protesters with signs in gallery of Los Angeles County Supervisors" \
        "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947",
        "Type.typeOfResource" => "still image",
        "Subject" => "Express highways--California--Los Angeles County--Design and construction|~|" \
        "Eminent domain--California--Los Angeles|~|Demonstrations--California--Los Angeles County|~|" \
        "Transportation|~|Government|~|Activism|~|Interstate 10",
        "Publisher.publisherName" => "Los Angeles Daily News",
        "Format.medium" => "1 photograph",
        "Rights.countryCreation" => "US",
        "Name.repository" => "University of California, Los Angeles. $b Library Special Collections",
        "Description.caption" => "This example does not have a caption.",
        # "File Name" => nil,
        "Coverage.geographic" => "Los Angeles (Calif.)",
        "Name.subject" => "Los Angeles County (Calif.). $b Board of Supervisors",
        "Photographer" => "Ansel Adams",
        "Language" => "English",
        "Uniform title" => "Protesters with signs in gallery of Los Angeles County Supervisors",
        "Support" => "Support" }
    end

    it "does not throw an error if File Name is empty" do
      expect(mapper.remote_files).to eq []
    end

    it "logs the missing file" do
      mapper.remote_files
      File.open(ENV['MISSING_FILE_LOG']) do |file|
        expect(file.read).to eq "Work ark:/21198/zz0002nq4w is missing a filename\n"
      end
    end
  end

  context 'with a blank filename for a "Collection" row' do
    let(:metadata) do
      { "Item ARK" => "123/abc",
        "Object Type" => "Collection",
        "Title" => "Collection Title" }
    end

    it 'doesn\'t log a missing file' do
      FileUtils.touch(ENV['MISSING_FILE_LOG'])
      expect(mapper.remote_files).to eq []
      File.open(ENV['MISSING_FILE_LOG']) do |file|
        expect(file.read).to eq ""
      end
    end
  end

  describe '#fields' do
    it 'has expected fields' do
      expect(mapper.fields).to include(
        :alternative_title,
        :architect,
        :ark,
        :caption,
        :date_created,
        :description,
        :dimensions,
        :dlcs_collection_name,
        :extent,
        :funding_note,
        :genre,
        :language,
        :latitude,
        :local_identifier,
        :location,
        :longitude,
        :medium,
        :named_subject,
        :normalized_date,
        :publisher,
        :photographer,
        :place_of_origin,
        :publisher,
        :repository,
        :remote_files,
        :resource_type,
        :rights_country,
        :rights_holder,
        :rights_statement,
        :services_contact,
        :subject,
        :support,
        :title,
        :uniform_title,
        :visibility
      )
    end
  end

  describe '#map_field' do
    let(:metadata) do
      { 'Single.source' => 'specific',
        'Source.one' => 'ecolog|~|next',
        'Source.two' => 'nihilism' }
    end

    it 'maps from a single source field' do
      stub_const('CalifornicaMapper::CALIFORNICA_TERMS_MAP', { 'single_source' => 'Single.source' })
      expect(mapper.map_field('single_source')).to eq(['specific'])
    end

    it 'maps from a list of source fields' do
      stub_const('CalifornicaMapper::CALIFORNICA_TERMS_MAP', { 'multi_source' => ['Source.one', 'Source.two'] })
      expect(mapper.map_field('multi_source')).to eq(['ecolog', 'next', 'nihilism'])
    end
  end

  describe '#ark' do
    it "maps the required ark field" do
      expect(mapper.ark).to eq('ark:/21198/zz0002nq4w')
    end

    context 'when input has no prefix' do
      let(:metadata) do
        { "Item ARK" => "21198/zz0002nq4w" }
      end

      it 'adds the prefix "ark:/"' do
        expect(mapper.ark).to eq('ark:/21198/zz0002nq4w')
      end
    end
  end

  describe '#extent' do
    context 'when collection is LADNN' do
      let(:metadata) do
        { "Project Name" => "Los Angeles Daily News Negatives",
          "Format.extent" => "This value is ignored" }
      end

      it 'hard codes the extent field' do
        expect(mapper.extent).to eq ['1 photograph']
      end
    end

    context 'when it doesn\'t require special handling' do
      let(:metadata) do
        { "Project Name" => "Another collection",
          "Format.extent" => "Ext 1|~|Ext 2" }
      end

      it 'reads the value from the metadata' do
        expect(mapper.extent).to contain_exactly("Ext 1", "Ext 2")
      end
    end
  end

  describe '#master_file_path' do
    context 'when the path starts with a \'/\'' do
      let(:metadata) { { 'File Name' => '/Masters/dlmasters/abc/xyz.tif' } }

      it 'gets removed' do
        expect(mapper.master_file_path).to eq 'Masters/dlmasters/abc/xyz.tif'
      end
    end

    context 'when the path starts with \'Masters/\'' do
      let(:metadata) { { 'File Name' => 'Masters/dlmasters/abc/xyz.tif' } }

      it 'imports as is' do
        expect(mapper.master_file_path).to eq 'Masters/dlmasters/abc/xyz.tif'
      end
    end

    context 'when the path doesn\'t start with \'Masters\'' do
      let(:metadata) { { 'File Name' => 'abc/xyz.tif' } }

      it 'prepends \'Masters/dlmasters\'' do
        expect(mapper.master_file_path).to eq 'Masters/dlmasters/abc/xyz.tif'
      end
    end
  end

  describe '#repository' do
    context 'when collection is LADNN' do
      let(:metadata) do
        { "Project Name" => "Los Angeles Daily News Negatives",
          "Name.repository" => "This value is ignored" }
      end

      it 'hard codes the repository field' do
        expect(mapper.repository).to eq ['University of California, Los Angeles. Library. Department of Special Collections']
      end
    end

    context 'when it doesn\'t require special handling' do
      let(:metadata) do
        { "Project Name" => "Another collection",
          "Name.repository" => "Repo 1|~|Repo 2" }
      end

      it 'reads the value from the metadata' do
        expect(mapper.repository).to contain_exactly("Repo 1", "Repo 2")
      end
    end

    context 'when it contains MaRC relators' do
      let(:metadata) do
        { "Project Name" => "Another Collection",
          "Name.repository" => "UCLA. $b Library Special Collections" }
      end
      it 'replaces them with a space' do
        expect(mapper.repository).to contain_exactly("UCLA. Library Special Collections")
      end
    end
  end

  describe '#subject' do
    context 'when it contains MaRC separators' do
      let(:metadata) do
        { "Project Name" => "Los Angeles Daily News Negatives",
          "Name.repository" => "Repo 1|~|Repo 2",
          "Subject" => "Wrestlers $z California $z Los Angeles|~|Los Angeles County (Calif.). $b Board of Supervisors" }
      end
      it 'replaces them with double dashes' do
        expect(mapper.subject).to contain_exactly("Wrestlers--California--Los Angeles", "Los Angeles County (Calif.).--Board of Supervisors")
      end
    end
  end

  describe '#named_subject' do
    context 'when it contains MaRC separators' do
      let(:metadata) do
        { "Project Name" => "Los Angeles Daily News Negatives",
          "Name.subject" => "Nagurski, Bronko, $d 1908-1990|~|Olympic Games $n (8th : $d 1924 : $c Paris, France)" }
      end
      it 'removes them and their surrounding spaces' do
        expect(mapper.named_subject).to contain_exactly("Nagurski, Bronko, 1908-1990", "Olympic Games (8th : 1924 : Paris, France)")
      end
    end
  end

  context "UCLA has not agreed to use rightsstatement.org" do
    describe '#rights_statement' do
      context 'when the field is blank' do
        # No value for "Rights.copyrightStatus"
        let(:metadata) { { 'Title' => 'A title' } }

        it 'returns \'unknown\'' do
          expect(mapper.rights_statement).to eq ["http://vocabs.library.ucla.edu/rights/unknown"]
        end
      end

      context 'with valid values' do
        let(:metadata) do
          { 'Title' => 'A title',
            'Rights.copyrightStatus' => ['copyrighted', 'unknown', 'public domain'].join('|~|') }
        end

        it 'finds the correct ID for the given value' do
          expect(mapper.rights_statement).to contain_exactly(
            "http://vocabs.library.ucla.edu/rights/copyrighted",
            "http://vocabs.library.ucla.edu/rights/publicDomain",
            "http://vocabs.library.ucla.edu/rights/unknown"
          )
        end
      end

      context 'with values that need to be mapped' do
        let(:metadata) do
          { 'Title' => 'A title',
            'Rights.copyrightStatus' => ['copyrighted', 'unknown', 'pd'].join('|~|') }
        end

        it 'finds the correct ID for the given value' do
          expect(mapper.rights_statement).to contain_exactly(
            "http://vocabs.library.ucla.edu/rights/copyrighted",
            "http://vocabs.library.ucla.edu/rights/publicDomain",
            "http://vocabs.library.ucla.edu/rights/unknown"
          )
        end
      end

      context 'with an invalid value' do
        let(:metadata) do
          { 'Title' => 'A title',
            'Rights.copyrightStatus' => 'something invalid' }
        end

        it 'returns the same value' do
          expect(mapper.rights_statement).to eq ['something invalid']
        end
      end
    end
  end

  describe '#photographer' do
    context 'when it contains MaRC relators' do
      let(:metadata) do
        { "Name.photographer" => "Connell, Will, $d 1898-1961" }
      end
      it 'replaces them with a space' do
        expect(mapper.photographer).to contain_exactly("Connell, Will, 1898-1961")
      end
    end
  end

  describe '#license' do
    context 'when the collection is LADNN' do
      let(:metadata) do
        { "Project Name" => 'Los Angeles Daily News Negatives' }
      end
      it 'assigns a cc license' do
        expect(mapper.license).to contain_exactly("https://creativecommons.org/licenses/by/4.0/")
      end
    end
    context 'when the collection is not LADNN' do
      let(:metadata) do
        { "Project Name" => 'Anything Else' }
      end
      it 'does not assign a license' do
        expect(mapper.license).to be_nil
      end
    end
  end

  describe '#visibility' do
    subject { mapper.visibility }

    let(:private_vis) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
    let(:disc_vis) { ::Work::VISIBILITY_TEXT_VALUE_DISCOVERY }
    let(:auth_vis) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
    let(:public_vis) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }

    context 'when visibility field is blank' do
      let(:metadata) { {} }

      it 'defaults to public visibility' do
        expect(mapper.visibility).to eq public_vis
      end
    end

    context 'visibility: private' do
      let(:metadata) { { 'Visibility' => 'private' } }
      it { is_expected.to eq private_vis }
    end

    context 'visibility: restricted' do
      let(:metadata) { { 'Visibility' => 'restricted' } }
      it { is_expected.to eq private_vis }
    end

    context 'visibility: discovery' do
      let(:metadata) { { 'Visibility' => 'discovery' } }
      it { is_expected.to eq disc_vis }
    end

    context 'visibility: authenticated' do
      let(:metadata) { { 'Visibility' => 'authenticated' } }
      it { is_expected.to eq auth_vis }
    end

    context 'visibility: registered' do
      let(:metadata) { { 'Visibility' => 'registered' } }
      it { is_expected.to eq auth_vis }
    end

    context 'visibility: UCLA' do
      let(:metadata) { { 'Visibility' => 'UCLA' } }
      it { is_expected.to eq auth_vis }
    end

    context 'visibility: public' do
      let(:metadata) { { 'Visibility' => 'public' } }
      it { is_expected.to eq public_vis }
    end

    context 'visibility: open' do
      let(:metadata) { { 'Visibility' => 'open' } }
      it { is_expected.to eq public_vis }
    end

    context 'with different capitalization and whitespace' do
      let(:metadata) { { 'Visibility' => ' Public  ' } }
      it { is_expected.to eq public_vis }
    end
  end
end
