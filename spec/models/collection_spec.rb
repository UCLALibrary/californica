# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Collection do
  subject(:collection) { described_class.new }

  context 'it has UCLA metadata' do
    subject(:work) { described_class.new }
    it_behaves_like 'a work with UCLA metadata'
  end

  describe 'with ARK' do
    let(:ark) { "ark:/coll/222" }
    let(:similar_ark) { 'ark:/coll/222111' }

    let(:collection) { FactoryBot.create(:collection, ark: ark) }
    let(:collection_with_similar_ark) { FactoryBot.create(:collection, ark: similar_ark) }

    # Clean up any old collections, so we know exactly what we're working with.
    before { described_class.destroy_all }

    describe '::find_by_ark' do
      let(:found) { described_class.find_by_ark(ark) }

      context 'two collections' do
        before do
          # Create the collections
          collection_with_similar_ark
          collection
        end

        it 'finds the correct collection' do
          expect(described_class.count).to eq 2
          expect(found).to eq collection
        end
      end

      context 'a collection with a similar ark' do
        before do
          collection_with_similar_ark # Create it
        end

        it 'doesn\'t return the wrong collection' do
          expect(described_class.count).to eq 1
          expect(found).to eq nil
        end
      end
    end

    describe '::find_or_create_by_ark' do
      let(:result) { described_class.find_or_create_by_ark(ark) }

      context 'when the collection already exists' do
        before { collection } # Create the collection

        it 'doesn\'t create a new collection' do
          expect { result }.to change { described_class.count }.by(0)
          expect(result).to eq collection
        end
      end

      context 'when the collection doesn\'t exist' do
        it 'creates a new collection' do
          expect { result }.to change { described_class.count }.to(1)
          expect(result.title).to eq ["Collection #{ark}"]
          expect(result.ark).to eq ark
          expect(result.edit_groups).to eq ['admin']
        end
      end
    end
  end

  # Re-calculating a collection's size is very expensive, and we need a way to turn it off during bulk import
  it 'can disable re-computing of size' do
    collection.recalculate_size = false
    expect(collection.recalculate_size).to eq false
    collection.recalculate_size = true
    expect(collection.recalculate_size).to eq true
  end
end
