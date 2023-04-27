# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Display a Work', type: :system, js: true do
  let(:work) { FactoryBot.create(:work, ark: 'ark:/abc/1234', iiif_manifest_url: 'https://iiif.library.ucla.edu/ark%3A%2F21198%2Fz13f64qn/manifest') }
  let(:admin) { FactoryBot.create(:admin) }

  context "as an admin" do
    it "displays expected fields" do
      login_as admin
      visit("/concern/works/#{work.id}")
      expect(page).to have_content work.title.first
      expect(page).to have_content work.subject.first
      expect(page).to have_content work.ark
    end
  end
end
