# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'locales changing the labels in forms', :clean, type: :system, js: true do
  context 'logged in as an admin user' do
    let(:admin) { FactoryBot.create :admin }
    before { login_as admin }

    scenario 'visiting the works list' do
      visit '/dashboard/my/works'
      expect(page).to have_content('Visibility')
      expect(page).not_to have_content('translation missing')
    end
  end
end
