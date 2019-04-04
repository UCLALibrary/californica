# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Create a new collection', :clean, type: :system, js: true do
  let(:admin) { FactoryBot.create :admin }
  let(:title) { "My Test Collection" }
  let(:ark)   { "ark:/abc/1234" }

  include_context 'with workflow'

  before do
    Hyrax::CollectionType.find_or_create_default_collection_type
    Hyrax::CollectionType.find_or_create_admin_set_type
  end

  context 'logged in as an admin user' do
    before { login_as admin }

    scenario 'successfully creates a new collection with an ark based identifier' do
      visit "/dashboard/my/collections"
      click_on 'New Collection'
      choose('User Collection')
      click_on 'Create collection'
      fill_in('Title', with: title)
      fill_in('Ark', with: ark)
      click_on 'Save'
      expect(page).to have_content title
      expect(find_field('Ark').value).to eq ark
      expect(page).to have_content 'Collection was successfully created.'
      collection = Collection.last
      expect(collection.id).to eq '4321-cba'
    end
  end
end
