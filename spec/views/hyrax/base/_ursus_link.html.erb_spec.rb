# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/base/_ursus_link.html.erb', type: :view do
  subject(:page) do
    render 'hyrax/base/ursus_link.html.erb', presenter: presenter
  end

  let(:presenter) { Hyrax::WorkPresenter.new(solr_doc, ability) }
  let(:solr_doc) do
    SolrDocument.new(
      id: '12345',
      ark_ssi: 'ark:/111/222',
      description_tesim: ['My Desc']
    )
  end
  let(:librarian) { FactoryBot.build(:admin) }
  let(:ability) { Ability.new(librarian) }

  context 'when the Ursus host is configured' do
    before { allow(Ursus::Record).to receive(:ursus_hostname).and_return('ursus.example.com') }

    it 'displays the Ursus link for this record' do
      expect(page).to have_link 'View this record in Ursus'
    end
  end

  context 'when the Ursus host is unknown' do
    before { allow(Ursus::Record).to receive(:ursus_hostname).and_return(nil) }

    it 'doesn\'t display the Ursus link' do
      expect(page).not_to have_link 'View this record in Ursus'
    end
  end
end
