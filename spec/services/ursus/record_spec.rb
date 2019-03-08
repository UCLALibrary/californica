# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Ursus::Record do
  before { TestRecord = Struct.new(:id, :ark) }
  after { Object.send(:remove_const, :TestRecord) if defined?(TestRecord) }

  describe '::url_for' do
    subject(:url) { described_class.url_for(record) }

    let(:record) { TestRecord.new('123', 'ark:/123/456') }

    context 'when the Ursus hostname is known' do
      before { allow(described_class).to receive(:ursus_hostname).and_return('ursus.example.com') }

      it 'returns a URL to the record in Ursus' do
        expect(url).to eq 'http://ursus.example.com/catalog/123'
      end
    end

    context 'when the Ursus hostname isn\'t known' do
      before { allow(described_class).to receive(:ursus_hostname).and_return(nil) }

      it 'returns nil' do
        expect(url).to eq nil
      end
    end
  end
end
