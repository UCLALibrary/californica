# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/base/attributes.html.erb', type: :view do
  subject(:page) do
    render 'hyrax/base/attributes.html.erb', presenter: presenter
  end

  let(:admin)         { FactoryBot.create(:admin) }
  let(:ability)       { instance_double('Hyrax::Ability') }
  let(:presenter)     { Hyrax::WorkPresenter.new(solr_document, ability) }
  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:work)          do
    # local_rights_statement: ['local_statement'])
    Work.new(title: ['title'],
             ark: 'ark:/abcde/1234567',
             author: ['author'],
             binding_note: 'binding_note',
             description: ['description'],
             extent: ['extent'],
             caption: ['caption'],
             dimensions: ['dimensions'],
             funding_note: ['funding_note'],
             genre: ['genre'],
             iiif_viewing_hint: 'iiif_viewing_hint',
             location: ['location'],
             latitude: ['latitude'],
             local_identifier: ['local'],
             longitude: ['longitude'],
             medium: ['medium'],
             named_subject: ['named_subject'],
             normalized_date: ['normalized_date'],
             page_layout: ['page_layout'],
             place_of_origin: ['place_of_origin'],
             repository: ['repostiory'],
             resource_type: ['resource_type'],
             rights_country: ['rights_country'],
             rights_holder: ['rights_holder'],
             subject_topic: ['subject_topic'],
             summary: ['summary'],
             support: ['support'],
             iiif_text_direction: 'iiif_text_direction',
             uniform_title: ['Old Uniform title'],
             condition_note: 'condition_note')
  end

  before do
    allow(ability).to receive(:admin?) { true }
  end

  it 'has author' do
    expect(page).to match(/author/)
  end
  it 'has binding_note' do
    expect(page).to match(/binding_note/)
  end
  it 'has caption' do
    expect(page).to match(/caption/)
  end
  it 'has dimesions' do
    expect(page).to match(/dimensions/)
  end
  it 'has extent' do
    expect(page).to match(/extent/)
  end
  it 'has funding_note' do
    expect(page).to match(/funding_note/)
  end
  it 'has genre' do
    expect(page).to match(/genre/)
  end
  it 'has iiif_viewing_hint' do
    expect(page).to match(/iiif_viewing_hint/)
  end
  it 'has latitude' do
    expect(page).to match(/latitude/)
  end
  it 'has location' do
    expect(page).to match(/location/)
  end
  it 'has local identifier' do
    expect(page).to match(/local/)
  end
  it 'has longitude' do
    expect(page).to match(/longitude/)
  end
  it 'has medium' do
    expect(page).to match(/medium/)
  end
  it 'has named_subject' do
    expect(page).to match(/named_subject/)
  end
  it 'has normalized_date' do
    expect(page).to match(/normalized_date/)
  end
  it 'has page_layout' do
    expect(page).to match(/page_layout/)
  end
  it 'has place_of_origin' do
    expect(page).to match(/place_of_origin/)
  end
  it 'has repo' do
    expect(page).to match(/repository/)
  end
  it 'has resource type' do
    expect(page).to match(/resource_type/)
  end
  it 'has rights_country' do
    expect(page).to match(/rights_country/)
  end
  it 'has rights_holder' do
    expect(page).to match(/rights_holder/)
  end
  it 'has subject_topic' do
    expect(page).to match(/subject_topic/)
  end
  it 'has summary' do
    expect(page).to match(/summary/)
  end
  it 'has support' do
    expect(page).to match(/support/)
  end
  it 'has iiif_text_direction' do
    expect(page).to match(/iiif_text_direction/)
  end
  it 'has uniform_title' do
    expect(page).to match(/uniform_title/)
  end
  it 'has condition_note' do
    expect(page).to match(/condition_note/)
  end
  #  it 'has local_rights_statement' do
  #    expect(page).to match(/local_rights_statement/)
  #  end
end
