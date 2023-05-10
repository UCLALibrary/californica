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
      author: ['Old Author'],
      binding_note: 'Old Binding note',
      calligrapher: ['Old Calligrapher'],
      citation_source: ['Old References'],
      contents_note: ['Old Contents note'],
      date_created: ['Old Creation Date'],
      description: ['Old Desc'],
      dimensions: ['Old Dim'],
      editor: ['Old Editor'],
      engraver: ['Old Engraver'],
      extent: ['Old Extent'],
      caption: ['Old Cap'],
      format_book: ['Old Format'],
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      iiif_manifest_url: 'Old Iiif manifest url',
      iiif_range: 'Old Iiif range',
      iiif_viewing_hint: 'Old Iiif viewing hint',
      illustrations_note: ['Old Illustrations note'],
      illustrator: ['Old Illustrator'],
      language: ['ang'],
      latitude: ['Old Lat'],
      longitude: ['Old Long'],
      local_identifier: ['Old Local ID'],
      location: ['Old Loc'],
      medium: ['Old Medium'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['1900/1901'],
      note: ['Old Note'],
      note_admin: ['Old AdminNote'],
      opac_url: 'https://www.library.ucla.edu',
      page_layout: ['Old Page layout'],
      photographer: ['Old Photographer'],
      place_of_origin: ['Old Place of origin'],
      printmaker: ['Old Printmaker'],
      program: ['Old Program'],
      provenance: ['Old Provenance'],
      publisher: ['Old Pub'],
      related_to: ['Old Related Items'],
      repository: ['Old Repository'],
      resource_type: ['Image'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      rights_statement: ['http://rightsstatements.org/vocab/InC/1.0/'], # "copyrighted"
      services_contact: ['UCLA Special Collections'],
      subject: ['Old Subj'],
      subject_topic: ['Old Subject topic'],
      summary: ['Old Summary'],
      support: ['Old Support'],
      iiif_text_direction: 'Old IIIF Text direction',
      title: ['Old Title'],
      toc: ['Old Table of contents'],
      uniform_title: ['Old Uniform title'],
      collation: 'Old Collation',
      composer: ['Old Composer'],
      foliation: 'Old Foliation note',
      illuminator: ['Old Illuminator'],
      lyricist: ['Old Lyricist'],
      masthead_parameters: 'Old Masthead Parameters',
      scribe: ['Old Scribe'],
      condition_note: 'Old Condition note',
      representative_image: 'Old Representative image',
      featured_image: 'Old Featured image',
      tagline: 'Old Tagline',
      commentator: ['Old Commentator'],
      subject_geographic: ['Old Subject geographic'],
      subject_temporal: ['Old Subject temporal'],
      subject_cultural_object: ['Old Subject cultural object'],
      subject_domain_topic: ['Old Subject domain topic'],
      translator: ['Old Translator'],
      colophon: ['Old Colophon'],
      finding_aid_url: ['Old Finding aid url'],
      rubricator: ['Old rubricator'],
      creator: ['Old name creator'],
      license: ['Creative Commons CC0 1.0 Universal'],
      local_rights_statement: ['Old Rights local statement'], # This invokes License renderer from hyrax gem
      content_disclaimer: ['Old Disclaimer'],
      interviewer: ['Old Interviewer'],
      interviewee: ['Old Interviewee'],
      cartographer: ['Old Cartographer'],
      artist: ['Old Artist'],
      recipient: ['Old Recipient'],
      director: ['Old Director'],
      producer: ['Old Producer'],
      series: ['Old Series'],
      host: ['Old Host'],
      musician: ['Old Musician'],
      printer: ['Old Printer'],
      researcher: ['Old Researcher'],
      resp_statement: ['Old Statement of Responsibility']
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
