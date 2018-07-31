# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ModsMapper do
  subject(:mapper) { described_class.new }
  let(:file)       { File.open(File.join(fixture_path, 'mods_example.xml')) }
  let(:mods_xml)   { Nokogiri::XML(file).xpath('//mods:mods', described_class::NAMESPACES) }

  describe '#fields' do
    it { expect(mapper.fields).to contain_exactly(:title, :depositor) }
  end

  describe '#title' do
    it 'is empty' do
      expect(mapper.title).to be_empty
    end

    context 'with metadata' do
      before { mapper.metadata = mods_xml }

      it 'has a title' do
        title = 'Elizabeth Klomp in court for shoplifting $10.45 of ' \
                'merchandise, Los Angeles, February 19, 1940'

        expect(mapper.title).to contain_exactly title
      end
    end
  end
end
