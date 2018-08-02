# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ModsXmlParser do
  subject(:parser) { described_class.for(file: file) }

  let(:file) { File.open(File.join(fixture_path, 'mods_example.xml')) }

  describe '.for' do
    it 'builds a parser for the given file' do
      expect(described_class.for(file: file)).to be_a described_class
    end
  end

  describe '#records' do
    let(:title) do
      'Elizabeth Klomp in court for shoplifting $10.45 of merchandise, Los ' \
      'Angeles, February 19, 1940'
    end

    it 'has a record with the correct title' do
      expect(parser.records.map(&:attributes).first[:title].first).to eq title
    end

    it "has a record with the batch depositor" do
      expect(parser.records.map(&:attributes).first[:depositor]).to eq User.batch_user.user_key
    end

    it 'has a record with the correct genre' do
      expect(parser.records.map(&:attributes).first[:genre]).to include('news photographs', 'cellulose nitrate film')
    end
  end
end
