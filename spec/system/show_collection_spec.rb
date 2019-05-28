# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Show a collection', :clean, type: :system, js: true do
  let(:collection) { FactoryBot.create(:collection_lw, user: admin) }
  let(:admin) { FactoryBot.create :admin }

  let(:collection_attrs) do
    {
      title: ['Old Title'],
      rights_statement: ['http://rightsstatements.org/vocab/InC/1.0/'], # "copyrighted"
      architect: ['Old Architect'],
      publisher: ['Old Pub'],
      date_created: ['Old Creation Date'],
      subject: ['Old Subj'],
      language: ['ang'],
      description: ['Old Desc'],
      resource_type: ['Image'],
      extent: ['Old Extent'],
      caption: ['Old Cap'],
      dimensions: ['Old Dim'],
      funding_note: ['Old Fund Note'],
      genre: ['Old Genre'],
      latitude: ['Old Lat'],
      longitude: ['Old Long'],
      local_identifier: ['Old Local ID'],
      medium: ['Old Medium'],
      named_subject: ['Old Name/Subj'],
      normalized_date: ['Old Normalized Date'],
      repository: ['Old Repository'],
      location: ['Old Loc'],
      rights_country: ['Old Rights Country'],
      rights_holder: ['Old Rights Holder'],
      photographer: ['Old Photographer'],
      services_contact: ['UCLA Special Collections']
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
