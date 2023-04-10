# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Delete a ChildWork', :clean, type: :system, js: true do
  let(:child_work) { FactoryBot.create(:child_work, ark: 'ark:/abc/1234', iiif_manifest_url: 'https://test.iiif.library.ucla.edu/collections/ark%3A%2F21198%2Fz11c574k') }
  let(:recreated_child_work) { FactoryBot.create(:child_work, ark: 'ark:/abc/1234', iiif_manifest_url: 'https://test.iiif.library.ucla.edu/collections/ark%3A%2F21198%2Fz11c574k') }

  let(:admin) { FactoryBot.create(:admin) }

  context "as an admin" do
    it "can re-create a deleted work with the same ark" do
      login_as admin
      visit("/concern/works/#{child_work.id}")
      expect(page).to have_content child_work.title.first
      expect(page).to have_content child_work.subject.first
      expect(page).to have_content child_work.ark

      # Now delete the work and create it again.
      visit "/concern/works/#{child_work.id}"
      click_on 'Delete'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content("Deleted #{child_work.title.first}")
      expect(ChildWork.count).to eq 0

      visit("/concern/works/#{recreated_child_work.id}")
      expect(page).to have_content recreated_child_work.title.first
      expect(page).to have_content recreated_child_work.subject.first
      expect(page).to have_content child_work.ark
    end
  end
end
