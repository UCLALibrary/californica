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
      date_created: ['Old Creation Date'],
      description: ['Old Desc'],
      dimensions: ['Old Dim'],
      extent: ['Old Extent'],
      caption: ['Old Cap'],
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      iiif_manifest_url: 'Old Iiif manifest url',
      iiif_range: 'Old Iiif range',
      iiif_viewing_hint: 'Old Iiif viewing hint',
      illustrations_note: ['Old Illustrations note'],
      language: ['ang'],
      latitude: ['Old Lat'],
      longitude: ['Old Long'],
      local_identifier: ['Old Local ID'],
      location: ['Old Loc'],
      medium: ['Old Medium'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['Old Normalized Date'],
      page_layout: ['Old Page layout'],
      photographer: ['Old Photographer'],
      place_of_origin: ['Old Place of origin'],
      provenance: ['Old Provenance'],
      publisher: ['Old Pub'],
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
      uniform_title: ['Old Uniform title']
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
