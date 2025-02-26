# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalifornicaMapper do
  subject(:mapper) { described_class.new }

  let(:metadata) do
    {
      "File Name" => "clusc_1_1_00010432a.tif", # access_copy, preservation_copy
      "AltTitle.other" => "alternative title", # alternative_title
      "AltTitle.translated" => "translated alternative title", # alternative_title
      "AltTitle.parallel" => "parallel alternative title", # alternative_title
      "Alternate Title.creator" => "alternative title creator", # alternative_title
      "Alternate Title.descriptive" => "descriptive alternative title", # alternative_title
      "Alternate Title.inscribed" => "alternative title inscribed", # alternative_title
      "Alternate Title.other" => "alternative title other", # alternative_title
      "AltTitle.descriptive" => "alternative titles descriptive", # alternative_title
      "Author" => "author", # author
      "Opac url" => "https://www.library.ucla.edu", # opac_url
      "Description.opac" => "description opac", # opac_url
      "Binding note" => "binding note", # binding_note
      "Description.binding" => "description binding", # binding_note
      "Name.architect" => "Imhotep", # architect
      "IIIF Manifest URL" => "http://test.url/iiif/manifest",
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
      "Local identifier" => "UCLA-1234e", # local_identifier
      "Coverage.geographic" => "Los Angeles (Calif.)", # location
      "Description.longitude" => "-118.243683", # longitude
      "Format.medium" => "photograph", # medium
      "Name.subject" => "Los Angeles County (Calif.). $b Board of Supervisors", # named_subject
      "Personal or Corporate Name.subject" => "LA County", # named_subject
      "Subject.personalName" => "Alan Smithee", # named_subject
      "Subject.corporateName" => "The Corporation", # named_subject
      "Date.normalized" => "July 4th 1947", # normalized_date
      "Name.photographer" => "Unknown", # photographer
      "Page layout" => "images", # page_layout
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
      "Subject.conceptTopic" => "Protesters with signs", # subject_topic
      "Subject.descriptiveTopic" => "Descriptive Protesters", # subject_topic
      "Support" => "Support", # support
      "Title" => "Protesters with signs in gallery of Los Angeles County Supervisors " \
        "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947", # title
      "AltTitle.uniform" => "Protesters with signs in gallery of Los Angeles County Supervisors", # uniform_title
      "Summary" => "Protesters with signs", # summary
      "Description.abstract" => "Abstract description", # summary
      # "Description.contents" => "Contents description", # contents_note
      "Description.history" => "Description history", # provenance
      "Text direction" => "left-to-right", # iiif_text_direction
      "viewingHint" => "paged", # iiif_viewing_hint
      "IIIF Range" => "iiif-range", # iiif_range
      "Illustrations note" => "illustration-note", # illustrations_note
      "Description.illustrations" => "description illustrations", # illustrations_note
      "Provenance" => "history-description", # provenance
      "Table of Contents" => "table of contents", # toc
      "Description.tableOfContents" => "description table of contents", # toc
      "Collation" => "Collation", # collation
      "Foliation note" => "Foliation note", # foliation
      "Foliation" => "Foliation", # foliation
      "Illuminator" => "Illuminator", # illuminator
      "Masthead" => "Masthead", # masthead_parameters
      "Name.illuminator" => "Illuminator name", # illuminator
      "Name.lyricist" => "Lyricist", # lyricist
      "Name.composer" => "Composer", # composer
      "Scribe" => "Scribe", # scribe
      "Name.scribe" => "Scribe", # scribe
      "Condtion note" => "condition_note", # condtion_note
      "Representative image" => "Representative image", # Representative image
      "Featured image" => "Featured image", # Featured image
      "Tagline" => "Tagline", # Tagline
      "Rights.statementLocal" => "Local rights statement-1", # local_rights_statement
      "Commentator" => "commentator old", # commentator
      "Name.commentator" => "name commentator old", # commentator
      "Subject geographic" => "geographic old", # subject_geogaphic
      "Subject temporal" => "temporal old", # subject_temporal
      "Translator" => "translator old", # translator
      "Name.translator" => "name translator old", # translator
      "Colophon" => "colophon text", # colophon
      "Description.colophon" => "colophon text 2", # colophon
      "Finding Aid URL" => "finding_aid_url_1", # finding_aid_url
      "Alt ID.url" => "finding_aid_url_2", # finding_aid_url
      "Rubricator" => "rubricator_1", # rubricator
      "Name.rubricator" => "rubricator_2", # rubricator
      "Name.creator" => "name_creator", # creator
      "License" => "http://creativecommons.org/publicdomain/zero/1.0/", # license
      "llustrator" => "Illustrator-1", # illustrator
      "Name.llustrator" => "Name-Illustrator", # illustrator
      "Calligrapher" => "Calligrapher-1", # calligrapher
      "Name.calligrapher" => "Name-calligrapher", # calligrapher
      "Editor" => "Editor-1", # editor
      "Name.editor" => "Name-editor", # editor
      "Engraver" => "Engraver-1", # engraver
      "Name.engraver" => "Name-engraver", # engraver
      "Note" => "Note-1", # note
      "Printmaker" => "Printmaker-1", # printmaker
      "Name.printmaker" => "Name-printmaker", # printmaker
      "Contents note" => "contents_note-1", # contents_note
      "Description.contents" => "Description-contents", # contents_note
      "Thumbnail" => "https://fake.url/iiif/ark%3A%2F21198%2Fzz0002nq4w", # thumbnail_link
      "Content disclaimer" => "Disclaimer-1", # content_disclaimer
      "Interviewer" => "Interviewee-1", # interviewee
      "Name.interviewer" => "Interviewee-2", # interviewee
      "Interviewee" => "Interviewer-1", # interviewer
      "Name.interviewee" => "Interviewer-2", # interviewer
      "Cartographer" => "Cartographer-1", # cartographer
      "Name.cartographer" => "Cartographer-2", # cartographer
      "Artist" => "Artist-1", # artist
      "Name.artist" => "Artist-2", # artist
      "Recipient" => "Recipient-1", # recipient
      "Name.recipient" => "Recipient-2", # recipient
      "Director" => "Director-1", # director
      "Name.director" => "Director-2", # director
      "Producer" => "Producer-1", # producer
      "Name.producer" => "Producer-2", # producer
      "Program" => "Program-1", # program
      "Subject.culturalObject" => "subject-culturalObject-1", # subject cultural object
      "Subject.domainTopic" => "subject-domain-topic-1", # subject domain topic
      "Series" => "Series-1", # series
      "Host" => "Host-1", # host
      "Name.host" => "Host-2", # host
      "Musician" => "Musician-1", # musician
      "Name.musician" => "Musician-2", # musician
      "Printer" => "Printer-1", # printer
      "Name.printer" => "Printer-2", # printer
      "Researcher" => "Researcher-1", # researcher
      "Name.researcher" => "Researcher-2", # researcher
      "Statement of Responsibility" => "Statement of Responsibility-1", # resp_statement
      "References" => "References-1", # citation_source
      "AdminNote" => "AdminNote-1", # note_admin
      "Description.adminnote" => "Description.adminnote-1", # note_admin
      "Note.admin" => "Note.admin-1", # note_admin
      "Format" => "Format-1", # format_book
      "Related Items" => "Related Items-1", # related_to
      "Edition" => "Edition-001", # edition
      "History" => "History-1", # history
      "Identifier" => "Identifier-1", # identifier
      "External item record" => "http://test.url/external/item/record", # electronic_locator
      "View Record" => "http://test.url/view/record", # electronic_locator
      "Arranger" => "Arranger-1", # arranger
      "Name.arranger" => "Arranger-2", # arranger
      "Collector" => "Collector-1", # collector
      "Name.collector" => "Collector-2", # collector
      "Inscription" => "Inscription-1", # inscription
      "Librettist" => "Librettist-1", # librettist
      "Name.librettist" => "Librettist-2", # librettist
      "Script" => "Script-1", # script
    }
  end

  before { mapper.metadata = metadata }

  it "maps resource type to local authority values, if possible" do
    expect(mapper.resource_type).to contain_exactly(
      'http://id.loc.gov/vocabulary/resourceTypes/img'
    )
  end

  it "maps license to local authority values, if possible" do
    expect(mapper.license).to contain_exactly(
      'http://creativecommons.org/publicdomain/zero/1.0/'
    )
  end

  it "maps IIIF Text direction to local authority values, if possible" do
    expect(mapper.iiif_text_direction).to eq 'http://iiif.io/api/presentation/2#leftToRightDirection'
  end

  it "maps the required title field" do
    expect(mapper.map_field(:title))
      .to contain_exactly("Protesters with signs in gallery of Los Angeles County Supervisors " \
                          "hearing over eminent domain for construction of Harbor Freeway, Calif., 1947")
  end

  it "maps the collection (relation.isPartOf) field" do
    expect(mapper.map_field(:dlcs_collection_name)).to contain_exactly("Connell (Will) Papers, 1928-1961")
  end

  describe '#fields' do
    it 'has expected fields' do
      expect(mapper.fields).to include(
        :alternative_title,
        :architect,
        :archival_collection_box,
        :archival_collection_folder,
        :archival_collection_number,
        :archival_collection_title,
        :ark,
        :arranger,
        :artist,
        :binding_note,
        :calligrapher,
        :caption,
        :cartographer,
        :citation_source,
        :collation,
        :collector,
        :colophon,
        :commentator,
        :composer,
        :condition_note,
        :content_disclaimer,
        :contents_note,
        :creator,
        :date_created,
        :description,
        :dimensions,
        :director,
        :dlcs_collection_name,
        :edition,
        :editor,
        :electronic_locator,
        :engraver,
        :extent,
        :featured_image,
        :finding_aid_url,
        :foliation,
        :format_book,
        :funding_note,
        :genre,
        :history,
        :host,
        :iiif_manifest_url,
        :iiif_text_direction,
        :iiif_viewing_hint,
        :illuminator,
        :illustrator,
        :inscription,
        :interviewee,
        :interviewer,
        :language,
        :latitude,
        :librettist,
        :license,
        :local_identifier,
        :local_rights_statement,
        :location,
        :longitude,
        :lyricist,
        :masthead_parameters,
        :medium,
        :musician,
        :named_subject,
        :normalized_date,
        :note,
        :note_admin,
        :opac_url,
        :page_layout,
        :photographer,
        :place_of_origin,
        :printer,
        :printmaker,
        :producer,
        :program,
        :provenance,
        :publisher,
        :publisher,
        :recipient,
        :related_record,
        :related_to,
        :repository,
        :representative_image,
        :researcher,
        :resource_type,
        :resp_statement,
        :rights_country,
        :rights_holder,
        :rights_statement,
        :rubricator,
        :scribe,
        :script,
        :series,
        :services_contact,
        :subject,
        :subject_cultural_object,
        :subject_domain_topic,
        :subject_geographic,
        :subject_temporal,
        :summary,
        :support,
        :tagline,
        :thumbnail_link,
        :title,
        :toc,
        :translator,
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

  describe '#local_rights_statement' do
    let(:metadata) do
      { "Rights.statementLocal" => "This is a local rights statement" }
    end
    it 'maps from the heading "Rights.statementLocal"' do
      expect(mapper.map_field(:local_rights_statement)).to eq(['This is a local rights statement'])
    end
  end

  describe '#genre' do
    let(:metadata) do
      { "Genre" => "Journalism" }
    end
    it 'maps from the heading "Genre"' do
      expect(mapper.map_field(:genre)).to eq(['Journalism'])
    end
  end

  describe '#access_copy' do
    context 'when the column is filled' do
      let(:metadata) { { 'access_copy' => 'https://my.cantaloupe/iiif/2/abcxyz' } }

      it 'uses that value' do
        expect(mapper.access_copy).to eq 'https://my.cantaloupe/iiif/2/abcxyz'
      end
    end

    context 'when the column is empty' do
      let(:metadata) do
        { 'File Name' => 'abc/xyz.tif',
          'access_copy' => '' }
      end

      it 'is nil' do
        expect(mapper.access_copy).to be_nil
      end
    end
  end

  describe '#iiif_manifest_url' do
    it "maps to a single-valued field" do
      expect(mapper.iiif_manifest_url).to eq('http://test.url/iiif/manifest')
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

  describe '#member_of_collections_attributes' do
    let(:metadata) do
      { "Parent ARK" => "ark:/123/abc" }
    end

    let(:collection) { FactoryBot.build(:collection, recalculate_size: true) }
    before { allow(Collection).to receive(:find_or_create_by_ark).and_return(collection) }

    it 'disables collection reindexing' do
      mapper.member_of_collections_attributes
      expect(collection.recalculate_size).to eq false
    end
  end

  describe '#preservation_copy' do
    context 'when the path begins with [volume].in.library.ucla.edu/' do
      let(:metadata) { { 'File Name' => 'masters.in.library.ucla.edu/dlmasters/abc/xyz.tif' } }

      it 'imports it unchanged' do
        expect(mapper.preservation_copy).to eq 'masters.in.library.ucla.edu/dlmasters/abc/xyz.tif'
      end

      context 'when the path starts with any number of initial `/` characters' do
        let(:metadata) { { 'File Name' => '//masters.in.library.ucla.edu/dlmasters/abc/xyz.tif' } }

        it 'ignores them' do
          expect(mapper.preservation_copy).to eq 'masters.in.library.ucla.edu/dlmasters/abc/xyz.tif'
        end
      end
    end

    context 'when the path is not supplied' do
      let(:metadata) { {} }

      it 'returns nil' do
        expect(mapper.preservation_copy).to be_nil
      end
    end

    context 'when the path is blank' do
      let(:metadata) { { 'File Name' => '' } }

      it 'returns nil' do
        expect(mapper.preservation_copy).to be_nil
      end
    end

    context 'when the path starts with \'Masters/\'' do
      let(:metadata) { { 'File Name' => 'Masters/dlmasters/abc/xyz.tif' } }

      it 'is interpreted relative to masters.in.library.ucla.edu/' do
        expect(mapper.preservation_copy).to eq 'masters.in.library.ucla.edu/dlmasters/abc/xyz.tif'
      end

      context 'when the path starts with any number of initial `/` characters' do
        let(:metadata) { { 'File Name' => '/Masters/dlmasters/abc/xyz.tif' } }

        it 'ignores them' do
          expect(mapper.preservation_copy).to eq 'masters.in.library.ucla.edu/dlmasters/abc/xyz.tif'
        end
      end
    end

    context 'when the path doesn\'t start with \'[volume].in.library.ucla.edu/\' or \'Masters\'' do
      let(:metadata) { { 'File Name' => 'abc/xyz.tif' } }

      it 'is interpreted relative to masters.in.library.ucla.edu/dlmasters/ (DLCSExport CSVs)' do
        expect(mapper.preservation_copy).to eq 'masters.in.library.ucla.edu/dlmasters/abc/xyz.tif'
      end

      context 'when the path starts with \'/\'' do
        let(:metadata) { { 'File Name' => '/abc/xyz.tif' } }

        it 'is interpreted the same way' do
          expect(mapper.preservation_copy).to eq 'masters.in.library.ucla.edu/dlmasters/abc/xyz.tif'
        end
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

    context 'when the repository column isn\'t name.repository' do
      let(:metadata) do
        { "Project Name" => "Another collection",
          "repository" => "Repo 1|~|Repo 2" }
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
    context 'when it has a header of "Subject name"' do
      let(:metadata) do
        { "Subject name" => "Nagurski, Bronko, $d 1908-1990|~|Olympic Games $n (8th : $d 1924 : $c Paris, France)" }
      end
      it 'works the same as other named_subect fields' do
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
      it 'does assign a license if the csv has license' do
        expect(mapper.license).not_to be_nil
      end
    end
  end

  describe '#local_identifier' do
    context 'when the header is "Local identifier"' do
      let(:metadata) do
        { 'Local identifier' => 'UCLA-1234e' }
      end

      it 'returns the same value' do
        expect(mapper.local_identifier).to eq ['UCLA-1234e']
      end
    end
  end

  describe '#thumbnail_link' do
    subject { mapper.thumbnail_link }

    it 'maps as a single-valued field' do
      expect(mapper.thumbnail_link).to eq('https://fake.url/iiif/ark%3A%2F21198%2Fzz0002nq4w')
    end
  end

  describe '#visibility' do
    subject { mapper.visibility }

    let(:private_vis) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
    let(:sinai_vis) { ::Work::VISIBILITY_TEXT_VALUE_SINAI }
    let(:auth_vis) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
    let(:public_vis) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }

    context 'when visibility field is not included in the csv' do
      context 'and \'Item Status\' is \'Completed\'' do
        let(:metadata) { { 'Item Status' => 'Completed' } }

        it 'sets visibility to public' do
          expect(mapper.visibility).to eq public_vis
        end
      end

      context 'and \'Item Status\' is \'Completed with minimal metadata\'' do
        let(:metadata) { { 'Item Status' => 'Completed with minimal metadata' } }

        it 'sets visibility to public' do
          expect(mapper.visibility).to eq public_vis
        end
      end

      context 'and \'Item Status\' is \'In progress\'' do
        let(:metadata) { { 'Item Status' => 'In progress' } }

        it 'sets visibility to private' do
          expect(mapper.visibility).to eq private_vis
        end
      end

      context 'and \'Item Status\' is \'Needs QA\'' do
        let(:metadata) { { 'Item Status' => 'Needs QA' } }

        it 'sets visibility to private' do
          expect(mapper.visibility).to eq private_vis
        end
      end

      context 'and \'Item Status\' is \'Needs Review\'' do
        let(:metadata) { { 'Item Status' => 'Needs Review' } }

        it 'sets visibility to private' do
          expect(mapper.visibility).to eq private_vis
        end
      end

      context 'and \'Item Status\' is Empty' do
        let(:metadata) { { 'Item Status' => nil } }

        it 'sets visibility to public' do
          expect(mapper.visibility).to eq public_vis
        end
      end
    end

    context 'when visibility field is included but blank' do
      let(:metadata) { { 'Item Status' => 'In progress', 'Visibility' => nil } }

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

    context 'visibility: sinai' do
      let(:metadata) { { 'Visibility' => 'sinai' } }
      it { is_expected.to eq sinai_vis }
    end

    context 'visibility: discovery' do
      let(:metadata) { { 'Visibility' => 'discovery' } }
      it { is_expected.to eq sinai_vis }
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
