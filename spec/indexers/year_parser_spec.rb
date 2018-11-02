# frozen_string_literal: true
require 'rails_helper'

RSpec.describe YearParser do
  describe '::integer_years' do
    subject { described_class.integer_years(dates) }

    context 'just the year' do
      let(:dates) { '1953' }
      it { is_expected.to eq [1953] }
    end

    context 'ISO 8601 date format' do
      let(:dates) { ['1941-10-01'] }
      it { is_expected.to eq [1941] }
    end

    context 'multiple dates' do
      let(:unsorted_dates) { ['1941-10-01', '1935', '1945'] }
      let(:dates) { unsorted_dates }
      let(:sorted_dates) { subject }

      it 'returns the years in sorted order' do
        expect(sorted_dates).to eq [1935, 1941, 1945]
      end
    end

    context 'when the date field is empty' do
      let(:dates) { nil }
      it { is_expected.to eq [] }
    end

    context 'with an unparseable value' do
      let(:unparseable) { 'ABCDEF' }
      let(:dates) { ['1953', unparseable] }
      let(:parsed_dates) { subject }

      it 'returns the years that it can parse' do
        expect(parsed_dates).to eq [1953]
      end
    end
  end
end
