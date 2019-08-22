# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Renderers::IiifViewingHintAttributeRenderer do
  subject(:renderer) { described_class.new(field, values) }
  let(:field)        { :iiif_viewing_hint }
  let(:labels)       { ['paged', 'individuals', 'continuous', 'non-paged', 'facing-pages'] }

  let(:values) { ['http://iiif.io/api/presentation/2#pagedHint', 'http://iiif.io/api/presentation/2#individualsHint', 'http://iiif.io/api/presentation/2#continuousHint', 'http://iiif.io/api/presentation/2#nonPagedHint', 'http://iiif.io/api/presentation/2#facingPagesHint'] }

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
