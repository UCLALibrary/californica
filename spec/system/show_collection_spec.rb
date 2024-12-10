# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Show a collection', :clean, type: :system, js: true do
  let(:collection) { FactoryBot.create(:collection_lw, user: admin) }
  let(:admin) { FactoryBot.create :admin }

  let(:collection_attrs) do
    {
      alternative_title: ['Alternative Title'],
      architect: ['Old Architect'],
      archival_collection_box: 'Box',
      archival_collection_folder: 'Folder',
      archival_collection_number: 'Archival Collection Number',
      archival_collection_title: 'Archival Collection Title',
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
      electronic_locator: 'External item record',
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
      iiif_manifest_url: 'Old Iiif manifest url',
      iiif_range: 'Old Iiif range',
      iiif_text_direction: 'Old IIIF Text direction',
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
      license: ['Creative Commons CC0 1.0 Universal'],
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
      related_record: ['RelatedRecords-1'],
      related_to: ['Old Related Items'],
      repository: ['Old Repository'],
      representative_image: 'Old Representative image',
      researcher: ['Old Researcher'],
      resource_type: ['Image'],
      resp_statement: ['Old Statement of Responsibility'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      rights_statement: ['http://rightsstatements.org/vocab/InC/1.0/'], # "copyrighted"
      rubricator: ['Old rubricator'],
      scribe: ['Old Scribe'],
      script: ['Old Script'],
      series: ['Old Series'],
      services_contact: ['UCLA Special Collections'],
      subject: ['Old Subj'],
      subject_cultural_object: ['Old Subject cultural object'],
      subject_domain_topic: ['Old Subject domain topic'],
      subject_geographic: ['Old Subject geographic'],
      subject_temporal: ['Old Subject temporal'],
      subject_topic: ['Old Subject topic'],
      summary: ['Old Summary'],
      support: ['Old Support'],
      tagline: 'Old Tagline',
      title: ['Old Title'],
      toc: ['Old Table of contents'],
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
    collection.recalculate_size = true
    collection.save
  end

  context 'the collection owner' do
    scenario 'sees all expected metadata for the collection on the public view' do
      login_as admin

      visit "/collections/#{collection.id}?locale=en"
      expect(page).to have_content collection.title.first

      collection_attrs.delete(:rights_statement) # Rights Statement display is a special case

      expect(page).to have_content collection.ark

      collection_attrs.each_value do |v|
        expect(page).to have_content v.first
      end
    end

    scenario 'sees all expected metadata for the collection on the dashboard view' do
      login_as admin

      visit "/dashboard/collections/#{collection.id}?locale=en"
      expect(page).to have_content collection.title.first

      collection_attrs.delete(:rights_statement) # Rights Statement display is a special case

      ark_value = collection_attrs.delete(:ark)
      expect(page).to have_content ark_value

      collection_attrs.each_value do |v|
        expect(page).to have_content v.first
      end
    end
  end
end
