
=begin
# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Delete a Work', :clean, type: :system, js: true do
  let(:work) { FactoryBot.create(:work, ark: 'ark:/abc/1234') }
  let(:recreated_work) { FactoryBot.create(:work, ark: 'ark:/abc/1234') }

  let(:admin) { FactoryBot.create(:admin) }

  context "as an admin" do
    it "can re-create a deleted work with the same ark" do
      login_as admin
      visit("/concern/works/#{work.id}")
      expect(page).to have_content work.title.first
      expect(page).to have_content work.subject.first
      expect(page).to have_content work.ark

      # Now delete the work and create it again.
      visit "/concern/works/#{work.id}"
      click_on 'Delete'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content("Deleted #{work.title.first}")
      expect(Work.count).to eq 0

      visit("/concern/works/#{recreated_work.id}")
      expect(page).to have_content recreated_work.title.first
      expect(page).to have_content recreated_work.subject.first
      expect(page).to have_content work.ark
    end
  end
end
=end

