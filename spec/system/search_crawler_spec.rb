# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Search History Page", :clean, type: :system, js: true do
  describe "crawler search" do
    it "doesn't remember human searches" do
      visit root_path
      fill_in "q", with: 'cat'
      expect { click_button 'Go' }.not_to change { Search.count }
    end

    it "doesn't remember bot searches", :clean, driver: :googlebot do
      visit root_path
      fill_in "q", with: 'cat'
      expect { click_button 'Go' }.not_to change { Search.count }
    end
  end
end
