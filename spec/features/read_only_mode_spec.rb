# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Read Only Mode' do
  let(:user)  { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create :admin }

  context 'a logged in user' do
    before { login_as admin }

    scenario "View Works", js: false do
      # read-only off
      visit("/concern/works/new")
      expect(page).to have_content("Requirements")
      allow(Flipflop).to receive(:read_only?).and_return(true)
      # read-only on
      visit("/concern/works/new")
      expect(page).to have_content("This system is in read-only mode for maintenance. No submissions or edits can be made at this time.")
      expect(page).to_not have_content("Requirements")
      # read-only off
      allow(Flipflop).to receive(:read_only?).and_return(false)
      visit("/concern/works/new")
      expect(page).to have_content("Requirements")
    end
  end
end
