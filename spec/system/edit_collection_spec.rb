# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Edit an existing collection', :clean, type: :system, js: true do
  let(:collection) { Collection.create!(collection_attrs) }
  let(:collection) { FactoryBot.create(:collection_lw, user: admin) }
  let(:admin) { FactoryBot.create :admin }

  let(:collection_attrs) do
    {
      alternative_title: ['alternative title'],
      architect: ['Old architect'],
      archival_collection_box: 'Old Box',
      archival_collection_folder: 'Old Folder',
      archival_collection_number: 'Old Archival Collection Number',
      archival_collection_title: 'Old Archival Collection Title',
      ark: 'ark:/abc/1234',
      arranger: ['Old Arranger'],
      artist: ['Old Artist'],
      author: ['Old Author'],
      binding_note: 'Old Binding note',
      calligrapher: ['Old Calligrapher'],
      caption: ['Old Cap'],
      cartographer: ['Old Cartographer'],
      citation_source: ['Old References'],
      collation: 'Old Collation',
      collector: ['Old Collector'],
      colophon: ['Old Colophon'],
      commentator: ['Old Commentator'],
      composer: ['Old Composer'],
      condition_note: 'Old Condition note',
      content_disclaimer: ['Old Disclaimer'],
      contents_note: ['Old Contents note'],
      creator: ['Old name creator'],
      date_created: ['Old Creation Date'],
      description: ['Old Desc'],
      dimensions: ['Old Dim'],
      director: ['Old Director'],
      edition: ['Old Edition'],
      editor: ['Old Editor'],
      electronic_locator: 'Old External item record',
      engraver: ['Old Engraver'],
      extent: ['Old Extent'],
      featured_image: 'Old Featured image',
      finding_aid_url: ['Old Finding aid url'],
      foliation: 'Old Foliation note',
      format_book: ['Old Format'],
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      history: ['Old History'],
      host: ['Old Host'],
      identifier: ['Old Identifier'],
      iiif_manifest_url: 'https://iiif.library.ucla.edu/collections/ark%3A%2F21198%2Fz11c574k',
      iiif_range: 'Old IIIF Range',
      iiif_text_direction: 'http://iiif.io/api/presentation/2#leftToRightDirection', # "left-to-right"
      iiif_viewing_hint: 'Old Iiif viewing hint',
      illuminator: ['Old Illuminator'],
      illustrations_note: ['Old Illustrations note'],
      illustrator: ['Old Illustrator'],
      inscription: ['Old Inscription'],
      interviewee: ['Old Interviewee'],
      interviewer: ['Old Interviewer'],
      language: ['ang'],
      latitude: ['Old Lat'],
      librettist: ['Old Librettist'],
      license: ['http://creativecommons.org/publicdomain/zero/1.0/'],
      local_identifier: ['Old Local ID'],
      local_rights_statement: ['Old Local rights statement'],
      location: ['Old Loc'],
      longitude: ['Old Long'],
      lyricist: ['Old Lyricist'],
      masthead_parameters: 'Old Masthead Parameters',
      medium: ['Old Medium'],
      musician: ['Old Musician'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['1900/1901'],
      note: ['Old Note'],
      note_admin: ['Old AdminNote'],
      opac_url: 'https://www.library.ucla.edu',
      page_layout: ['Old Page layout'],
      photographer: ['Old Photographer'],
      place_of_origin: ['Old Place of origin'],
      printer: ['Old Printer'],
      printmaker: ['Old Printmaker'],
      producer: ['Old Producer'],
      program: ['Old Program'],
      provenance: ['Old Provenance'],
      publisher: ['Old Pub'],
      recipient: ['Old Recipient'],
      related_record: ['Old Related Records'],
      related_to: ['Old Related Items'],
      repository: ['Old Repository'],
      representative_image: 'Old Representative image',
      researcher: ['Old Researcher'],
      resource_type: ['http://id.loc.gov/vocabulary/resourceTypes/col'], # "collection"
      resp_statement: ['Old Statement of Responsibility'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted'], # "copyrighted"
      rubricator: ['Old rubricator'],
      scribe: ['Old Scribe'],
      script: ['Old Script'],
      series: ['Old Series'],
      services_contact: ['Old Services Contact'],
      subject: ['Old Subj'],
      subject_cultural_object: ['Old Subject cultural object'],
      subject_domain_topic: ['Old Subject domain topic'],
      subject_geographic: ['Old Subject geographic'],
      subject_temporal: ['Old Subject temporal'],
      subject_topic: ['Old Subject Topic'],
      summary: ['Old Summary'],
      support: ['Old Supprt'],
      tagline: 'Old Tagline',
      title: ['Old Title'],
      toc: ['Old Table of Contents'],
      translator: ['Old Translator'],
      uniform_title: ['Old Uniform title']
    }
  end

  include_context 'with workflow'

  before do
    # Set all the attributes of collection
    # Normally we'd do this in the FactoryBot factory, but in this case we want
    # to use the Hyrax factories.
    collection_attrs.each do |k, v|
      collection.send((k.to_s + "=").to_sym, v)
    end
    collection.save
  end

  context 'logged in as an admin user' do
    before { login_as admin }

    scenario 'successfully edits the work' do
      visit "/dashboard/collections/#{collection.id}/edit"

      # When the form first loads, it should contain all the old values
      # expect(page.all(:css, 'div.select.work_rights_statement/select').first.text).to eq 'copyrighted'
      expect(first(:css, '#collection_description').value).to eq 'Old Desc'
      click_on 'Additional fields'
      expect(find_field('Publisher').value).to eq 'Old Pub'
      expect(find_field('Date Created').value).to eq 'Old Creation Date'
      expect(find_field('Subject').value).to eq 'Old Subj'
      expect(page).to have_select('Language', selected: 'English, Old (ca. 450-1100)', multiple: true)
      expect(find_field('Resource type').value).to eq ["http://id.loc.gov/vocabulary/resourceTypes/col"]
      expect(find_field('Extent').value).to eq 'Old Extent'
      expect(find_field('Caption').value).to eq 'Old Cap'
      expect(find_field('Dimensions').value).to eq 'Old Dim'
      expect(find_field('Edition').value).to eq 'Old Edition'
      expect(find_field('External item record').value).to eq 'Old External item record'
      expect(find_field('Funding Note').value).to eq 'Old Fund Note'
      expect(find_field('Genre').value).to eq 'Old Genre'
      expect(find_field('History').value).to eq 'Old History'
      expect(find_field('Identifier').value).to eq 'Old Identifier'
      expect(find_field('Iiif manifest url').value).to eq 'https://iiif.library.ucla.edu/collections/ark%3A%2F21198%2Fz11c574k'
      expect(find_field('Iiif range').value).to eq 'Old IIIF Range'
      expect(find_field('Illustrations note').value).to eq 'Old Illustrations note'
      expect(find_field('Latitude').value).to eq 'Old Lat'
      expect(find_field('Longitude').value).to eq 'Old Long'
      expect(find_field('Local Identifier').value).to eq 'Old Local ID'
      expect(find_field('Medium').value).to eq 'Old Medium'
      expect(find_field('Name (Subject)').value).to eq 'Old Name/Subj'
      expect(find_field('Normalized Date').value).to eq '1900/1901'
      expect(find_field('Page layout').value).to eq 'Old Page layout'
      expect(find_field('Provenance').value).to eq 'Old Provenance'
      expect(find_field('Repository').value).to eq 'Old Repository'
      expect(find_field('Place of origin').value).to eq 'Old Place of origin'
      # expect(find_field('Location').value).to eq 'Old Loc'
      expect(find_field('Rights (country of creation)').value).to eq 'Old Rights Country'
      expect(find_field('Rights Holder').value).to eq 'Old Rights Holder'
      expect(find_field('Photographer').value).to eq 'Old Photographer'
      expect(find_field('Summary').value).to eq 'Old Summary'
      expect(find_field('Rights services contact').value).to eq 'Old Services Contact'
      expect(find_field('Toc').value).to eq 'Old Table of Contents'
      expect(find_field('Subject topic').value).to eq 'Old Subject Topic'
      expect(find_field('Opac url').value).to eq 'https://www.library.ucla.edu'
      expect(find_field('Binding note').value).to eq 'Old Binding note'
      expect(page).to have_select('Iiif text direction', selected: 'left-to-right', multiple: false)
      expect(find_field('Uniform title').value).to eq 'Old Uniform title'
      expect(find_field('Collation').value).to eq 'Old Collation'
      expect(find_field('Composer').value).to eq 'Old Composer'
      expect(find_field('Foliation').value).to eq 'Old Foliation note'
      expect(find_field('Lyricist').value).to eq 'Old Lyricist'
      expect(find_field('Illuminator').value).to eq 'Old Illuminator'
      expect(find_field('Masthead').value).to eq 'Old Masthead Parameters'
      expect(find_field('Scribe').value).to eq 'Old Scribe'
      expect(find_field('Condition note').value).to eq 'Old Condition note'
      expect(find_field('Contents note').value).to eq 'Old Contents note'
      expect(find_field('Local rights statement').value).to eq 'Old Local rights statement'
      expect(find_field('Representative image').value).to eq 'Old Representative image'
      expect(find_field('Featured image').value).to eq 'Old Featured image'
      expect(find_field('Tagline').value).to eq 'Old Tagline'
      expect(find_field('Commentator').value).to eq 'Old Commentator'
      expect(find_field('Subject temporal').value).to eq 'Old Subject temporal'
      expect(find_field('Subject cultural object').value).to eq 'Old Subject cultural object'
      expect(find_field('Subject domain topic').value).to eq 'Old Subject domain topic'
      expect(find_field('Subject geographic').value).to eq 'Old Subject geographic'
      expect(find_field('Translator').value).to eq 'Old Translator'
      expect(find_field('Colophon').value).to eq 'Old Colophon'
      expect(find_field('Finding aid url').value).to eq 'Old Finding aid url'
      expect(find_field('Rubricator').value).to eq 'Old rubricator'
      expect(find_field('Creator').value).to eq 'Old name creator'
      expect(page).to have_select('License', selected: 'Creative Commons CC0 1.0 Universal', multiple: false)
      expect(find_field('Calligrapher').value).to eq 'Old Calligrapher'
      expect(find_field('Engraver').value).to eq 'Old Engraver'
      expect(find_field('Editor').value).to eq 'Old Editor'
      expect(find_field('Note').value).to eq 'Old Note'
      expect(find_field('Printmaker').value).to eq 'Old Printmaker'
      expect(find_field("Artist").value).to eq 'Old Artist'
      expect(find_field("Cartographer").value).to eq 'Old Cartographer'
      expect(find_field("Content disclaimer").value).to eq 'Old Disclaimer'
      expect(find_field("Interviewee").value).to eq 'Old Interviewee'
      expect(find_field("Interviewer").value).to eq 'Old Interviewer'
      expect(find_field("Director").value).to eq 'Old Director'
      expect(find_field("Producer").value).to eq 'Old Producer'
      expect(find_field("Program").value).to eq 'Old Program'
      expect(find_field("Recipient").value).to eq 'Old Recipient'
      expect(find_field("Series").value).to eq 'Old Series'
      expect(find_field("Host").value).to eq 'Old Host'
      expect(find_field("Musician").value).to eq 'Old Musician'
      expect(find_field("Printer").value).to eq 'Old Printer'
      expect(find_field("Researcher").value).to eq 'Old Researcher'
      expect(find_field('Citation source').value).to eq 'Old References'
      expect(find_field('Resp statement').value).to eq 'Old Statement of Responsibility'
      expect(find_field('Note admin').value).to eq 'Old AdminNote'
      expect(find_field('Format book').value).to eq 'Old Format'
      expect(find_field('Related to').value).to eq 'Old Related Items'
      expect(find_field('Related record').value).to eq 'Old Related Records'
      expect(find_field('Archival collection title').value).to eq 'Old Archival Collection Title'
      expect(find_field('Archival collection number').value).to eq 'Old Archival Collection Number'
      expect(find_field('Archival collection box').value).to eq 'Old Box'
      expect(find_field('Archival collection folder').value).to eq 'Old Folder'
      expect(find_field('Arranger').value).to eq 'Old Arranger'
      expect(find_field('Collector').value).to eq 'Old Collector'
      expect(find_field('Inscription').value).to eq 'Old Inscription'
      expect(find_field('Librettist').value).to eq 'Old Librettist'
      expect(find_field('Script').value).to eq 'Old Script'

      # Edit some fields in the form
      fill_in 'Title', with: 'New Title'
      fill_in 'Description', with: 'New Description'
      fill_in 'Extent', with: 'New Extent'

      click_on 'Save changes'
      expect(page).to have_current_path("/dashboard/collections/#{collection.id}/edit?locale=en")

      # Now the form should have the new values
      expect(page).to     have_content 'New Title'
      expect(page).not_to have_content 'Old Title'
      expect(page).to     have_content 'New Description'
      expect(page).to_not have_content 'Old Desc'
      col = Collection.last
      expect(col.extent).to eq ["New Extent"]
    end
  end
end
