# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Search the catalog', :clean, type: :system, js: true do
  # Create works with unique values for each field.
  # This metadata is contrived so we can test different types of searches.

  let!(:banana) do
    Work.create!(
      title: ['Yellow Banana'],
      architect: ['David Allison', 'George W. Kelham'],
      ark: 'ark:/abc/123456',
      visibility: visible,
      subject: ['fruit'],
      named_subject: ['dessert'],
      location: ['on the table'],
      description: ['potassium', 'yum'],
      caption: ['tropical'],
      identifier: ['ban_ark'],
      local_identifier: ['12345'],
      normalized_date: ['2015-10-06'],
      photographer: ['Sherlock'],
      place_of_origin: ['London'],
      support: ['Support'],
      uniform_title: ['Yellow Banana']
    )
  end

  let!(:carrot) do
    Work.create!(
      title: ['Orange Carrot'],
      architect: ['A. Quincy Jones'],
      ark: 'ark:/abc/67890',
      visibility: visible,
      subject: ['veg'],
      named_subject: ['side dish'],
      location: ['in the fridge'],
      description: ['beta carotene', 'yum'],
      caption: ['northern'],
      identifier: ['car_ark'],
      local_identifier: ['67890'],
      normalized_date: ['2018-07-07'],
      photographer: ['Watson'],
      support: ['UCLA'],
      place_of_origin: ['Scotland Yard']
    )
  end

  let(:visible) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }

  scenario 'get correct search results' do
    expect(Work.count).to eq 2
    visit root_path

    # When we first load the page, we should see all records
    within '#search-results' do
      expect(page).to have_link('Yellow Banana')
      expect(page).to have_link('Orange Carrot')
    end

    # Search by title
    fill_in 'search-field-header', with: 'yellow'
    click_on 'search-submit-header'

    # Search results should match on title
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end

    # Search by subject
    fill_in 'search-field-header', with: 'veg'
    click_on 'search-submit-header'

    # Search results should match on subject
    within '#search-results' do
      expect(page).to_not have_link('Yellow Banana')
      expect(page).to     have_link('Orange Carrot')
    end

    # Search by architect
    fill_in 'search-field-header', with: 'kelham'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end

    # Search by named_subject
    fill_in 'search-field-header', with: 'dessert'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end

    # Search by location
    fill_in 'search-field-header', with: 'fridge'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to_not have_link('Yellow Banana')
      expect(page).to     have_link('Orange Carrot')
    end

    # Search by description
    fill_in 'search-field-header', with: 'potassium yum'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end

    # Search by caption
    fill_in 'search-field-header', with: 'tropical'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end

    # Search by identifier
    fill_in 'search-field-header', with: 'ban_ark'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end

    # Search by local_identifier
    fill_in 'search-field-header', with: '67890'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to_not have_link('Yellow Banana')
      expect(page).to     have_link('Orange Carrot')
    end

    # Search by normalized_date
    fill_in 'search-field-header', with: '2018'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to_not have_link('Yellow Banana')
      expect(page).to     have_link('Orange Carrot')
    end

    # Search by photographer
    fill_in 'search-field-header', with: 'Sherlock'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end

    # Search by ark
    fill_in 'search-field-header', with: 'ark:/abc/123456'
    click_on 'search-submit-header'
    within '#search-results' do
      expect(page).to     have_link('Yellow Banana')
      expect(page).to_not have_link('Orange Carrot')
    end
  end
end
