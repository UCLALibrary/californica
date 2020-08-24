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
      expect(page).to have_content("New Collection")
      expect(page).to have_content("Title")
      click_on 'New Collection'
      choose('User Collection')
      click_on 'Create collection'
      fill_in('Title', with: 'My Test Collection')
      ### fill_in('Title', with: title)
      fill_in('Ark', with: 'ark:/abc/1234')
      ### fill_in('Ark', with: ark)
      click_on 'Save'
      expect(page).to have_content 'My Test Collection'
      expect(find_field('Ark').value).to eq 'ark:/abc/1234'
      # expect(page).to have_content title
      # expect(find_field('Ark').value).to eq ark
      expect(page).to have_content 'Collection was successfully created.'
      collection = Collection.last
      expect(collection.id).to eq '4321-cba'

      # If you delete the collection, you should be able to re-create it with the same ark
      visit "/dashboard/collections/#{collection.id}"
      click_on 'Delete collection'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content("Collection was successfully deleted")
      expect(Collection.count).to eq 0

      visit "/dashboard/my/collections"
      click_on 'New Collection'
      expect(page).to have_content("User Collection")
      choose('User Collection')
      click_on 'Create collection'
      expect(page).to have_content("Title")
      fill_in('Title', with: 'My Test Collection')
      ### fill_in('Title', with: title)
      fill_in('Ark', with: 'ark:/abc/1234')
      ### fill_in('Ark', with: ark)
      click_on 'Save'
      expect(page).to have_content("Title")
      expect(find_field('Ark').value).to eq ark
      expect(page).to have_content 'Collection was successfully created.'
      expect(Collection.count).to eq 1
      collection = Collection.last
      expect(collection.id).to eq '4321-cba'
    end
  end
end
