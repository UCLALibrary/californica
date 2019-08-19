# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Renderers::IiifTextDirectionAttributeRenderer do
  subject(:renderer) { described_class.new(field, values) }
  let(:field)        { :text_direction }
  let(:labels)       { ['left-to-right', 'right-to-left'] }

  let(:values) { ['http://iiif.io/api/presentation/2#leftToRightDirection', 'http://iiif.io/api/presentation/2#rightToLeftDirection'] }

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
