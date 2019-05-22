# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Renderers::LanguageRenderer do
  subject(:renderer) { described_class.new(field, values) }
  let(:field)        { :language }
  let(:labels)       { ['English', 'Klingon (Artificial language)'] }

  let(:values) { ['eng', 'tlh'] }

  describe '#render' do
    it 'has the labels' do
      expect(renderer.render).to include(*labels)
    end

    context 'with unexpected values' do
      let(:values) { ['moomin', 'hattifatteners'] }

      it 'shows the values instead' do
        expect(renderer.render).to include(*values)
      end
    end
  end
end
