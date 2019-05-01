# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Renderers::ResourceTypeAttributeRenderer do
  subject(:renderer) { described_class.new(field, values) }
  let(:field)        { :resource_type }
  let(:labels)       { ['collection', 'still image'] }

  let(:values) { ['http://id.loc.gov/vocabulary/resourceTypes/col', 'http://id.loc.gov/vocabulary/resourceTypes/img'] }

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
