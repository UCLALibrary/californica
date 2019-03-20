# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "Search History Page", :clean do
  describe "crawler search" do
    it "doesn't remember human searches" do
      visit root_path
      fill_in "q", with: 'cat'
      expect { click_button 'Go' }.not_to change { Search.count }
    end

    it "doesn't remember bot searches", :clean do
      page.driver.header('User-Agent', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)')
      visit root_path
      fill_in "q", with: 'cat'
      expect { click_button 'Go' }.not_to change { Search.count }
    end
  end
end
