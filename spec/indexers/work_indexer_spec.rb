# frozen_string_literal: true
require 'rails_helper'

RSpec.describe WorkIndexer do
  let(:solr_document) { indexer.generate_solr_document }
  let(:work) { Work.new(attributes) }

  let(:indexer) { described_class.new(work) }

  describe 'combined_subject' do
    let(:attributes) do
      {
        ark: 'ark:/123/456',
        subject: ['Subject 1', 'Subject 2'],
        named_subject: ['Named Subject'],
        subject_topic: ['Subject Topic'],
        subject_geographic: ['Subject Geographic']
      }
    end

    it 'combines the relevant subject fields' do
      expect(solr_document['combined_subject_ssim']).to contain_exactly('Subject 1', 'Subject 2', 'Named Subject', 'Subject Topic', 'Subject Geographic')
    end

    context 'When subject fields are missing' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          named_subject: ['Named Subject'],
          subject_topic: ['Subject Topic']
        }
      end

      it 'combines the fields that are present' do
        expect(solr_document['combined_subject_ssim']).to contain_exactly('Named Subject', 'Subject Topic')
      end
    end
  end

  describe 'resource type' do
    context 'a work with a resource type' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          resource_type: ['http://id.loc.gov/vocabulary/resourceTypes/img']
        }
      end

      it 'indexes a human-readable resource type' do
        expect(solr_document['human_readable_resource_type_tesim']).to eq ['still image']
      end
    end

    # This should never happen in production data,
    # but if it does, handle it gracefully.
    context 'when there is no human-readable value' do
      let(:no_match) { "a resource type that doesn't have a matching value in config/authorities/resource_types.yml" }
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          resource_type: [no_match, 'http://id.loc.gov/vocabulary/resourceTypes/img']
        }
      end

      it 'just returns the original value' do
        expect(solr_document['human_readable_resource_type_tesim']).to contain_exactly(no_match, 'still image')
      end
    end
  end

  describe 'test human_readable_related_record_title' do
    context 'a work with a human_readable_related_record_title' do
      let(:related_attributes1) do
        {
          ark: 'ark:/123/459',
          title: ['title 1 for ark:/123/459']
        }
      end
      let(:related_attributes2) do
        {
          ark: 'ark:/123/457',
          title: ['title 2 for ark:/123/457']
        }
      end
      let(:related_attributes3) do
        {
          ark: 'ark:/123/458',
          title: ['title 3 for ark:/123/458']
        }
      end

      let(:attributes) do
        {
          ark: 'ark:/123/456',
          title: ['Test Title'],
          related_record: ['ark:/123/459', 'ark:/123/457', 'ark:/123/458']
        }
      end
      let(:related_work1) { Work.new(related_attributes1) }
      let(:related_work2) { Work.new(related_attributes2) }
      let(:related_work3) { Work.new(related_attributes3) }

      before do
        allow(Work).to receive(:find_by_ark) do |ark_string|
          if ark_string == "ark:/123/459"
            related_work1
          elsif ark_string == "ark:/123/457"
            related_work2
          elsif ark_string == "ark:/123/458"
            related_work3
          end
        end
      end

      it 'indexes a human-readable related record title text' do
        expect(solr_document['human_readable_related_record_title_ssm']).to eq ['title 1 for ark:/123/459', 'title 2 for ark:/123/457', 'title 3 for ark:/123/458']
      end
    end
  end

  describe 'IIIF Text direction' do
    context 'a work with a IIIF Text direction' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          iiif_text_direction: 'http://iiif.io/api/presentation/2#leftToRightDirection'
        }
      end

      it 'indexes a human-readable IIIF Text direction' do
        expect(solr_document['human_readable_iiif_text_direction_ssi']).to eq 'left-to-right'
      end
    end

    # This should never happen in production data,
    # but if it does, handle it gracefully.
    context 'when there is no human-readable value' do
      let(:no_match) { "a IIIF Text direction that doesn't have a matching value in config/authorities/iiif_text_directions.yml" }
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          iiif_text_direction: 'http://iiif.io/api/presentation/2#leftToRightDirection'
        }
      end

      it 'just returns the original value' do
        expect(solr_document['human_readable_iiif_text_direction_ssi']).to eq 'left-to-right'
      end
    end
  end

  describe 'Iiif viewing hint' do
    context 'a work with a Iiif viewing hint' do
      let(:attributes) do
        {
          ark: 'ark:/123/458',
          iiif_viewing_hint: 'http://iiif.io/api/presentation/2#pagedHint'
        }
      end

      it 'indexes a human-readable Iiif viewing hint' do
        expect(solr_document['human_readable_iiif_viewing_hint_ssi']).to eq 'paged'
      end
    end

    # This should never happen in production data,
    # but if it does, handle it gracefully.
    context 'when there is no human-readable value' do
      let(:no_match) { "a Iiif viewing hint that doesn't have a matching value in config/authorities/iiif_viewing_hint.yml" }
      let(:attributes) do
        {
          ark: 'ark:/123/458',
          iiif_viewing_hint: 'http://iiif.io/api/presentation/2#pagedHint'
        }
      end

      it 'just returns the original value' do
        expect(solr_document['human_readable_iiif_viewing_hint_ssi']).to eq 'paged'
      end
    end
  end

  describe 'rights statement' do
    context 'a work with a rights statement' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          rights_statement: ['http://vocabs.library.ucla.edu/rights/copyrighted']
        }
      end

      it 'indexes a human-readable rights statement' do
        expect(solr_document['human_readable_rights_statement_tesim']).to eq ['copyrighted']
      end
    end

    # This should never happen in production data,
    # but if it does, handle it gracefully.
    context 'when there is no human-readable value' do
      let(:no_match) { "a rights statement that doesn't have a matching value in config/authorities/rights_statements.yml" }
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          rights_statement: [no_match, 'http://vocabs.library.ucla.edu/rights/copyrighted']
        }
      end

      it 'just returns the original value' do
        expect(solr_document['human_readable_rights_statement_tesim']).to contain_exactly(no_match, 'copyrighted')
      end
    end
  end

  describe 'language' do
    context 'a work with a language' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          language: ['eng']
        }
      end

      it 'indexes a human-readable language' do
        expect(solr_document['human_readable_language_tesim']).to eq ['English']
      end
    end

    # This should never happen in production data,
    # but if it does, handle it gracefully.
    context 'when there is no human-readable value' do
      let(:no_match) { "a language that doesn't have a matching value in config/authorities/languages.yml" }
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          language: [no_match, 'ang']
        }
      end

      it 'just returns the original value' do
        expect(solr_document['human_readable_language_tesim']).to contain_exactly(
          no_match,
          'English, Old (ca. 450-1100)'
        )
      end
    end
  end

  describe 'latitude and longitude' do
    context 'a work with latitude and longitude' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          latitude: ['45.0'],
          longitude: ['-93.0']
        }
      end

      it 'indexes the coordinates in a single field' do
        expect(solr_document['geographic_coordinates_ssim']).to eq '45.0, -93.0'
      end
    end

    context 'a work that is missing latitude' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          longitude: ['-93.0']
        }
      end

      it 'doesn\'t index the coordinates' do
        expect(solr_document['geographic_coordinates_ssim']).to eq nil
      end
    end

    context 'a work that is missing longitude' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          latitude: ['45.0']
        }
      end

      it 'doesn\'t index the coordinates' do
        expect(solr_document['geographic_coordinates_ssim']).to eq nil
      end
    end
  end

  describe 'integer years for date slider facet' do
    context 'with a normalized_date' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          normalized_date: ['1940']
        }
      end

      it 'indexes the year' do
        expect(solr_document['year_isim']).to eq [1940]
        expect(solr_document['date_dtsim']).to eq [Date.strptime('1940', "%Y").to_time.utc.iso8601]
      end
    end

    context 'when normalized_date field is blank' do
      let(:attributes) do
        {
          ark: 'ark:/123/456'
        }
      end

      it 'doesn\'t index the year' do
        expect(solr_document['year_isim']).to eq nil
        expect(solr_document['date_dtsim']).to eq nil
      end
    end

    context 'when normalized_date field includes negative (BCE) values' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          normalized_date: ['-0023/0003']
        }
      end

      it 'only indexes from year 0' do
        expect(solr_document['year_isim']).to contain_exactly(0, 1, 2, 3)
      end
    end
  end

  describe 'sort_year' do
    context 'with a normalized_date' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          normalized_date: ['1940-10-15']
        }
      end

      it 'indexes the earliest year' do
        expect(solr_document['sort_year_isi']).to eq 1940
        expect(solr_document['date_dtsim']).to eq [Date.strptime('1940-10-15', "%Y-%m-%d").to_time.utc.iso8601]
      end
    end

    context 'when normalized_date field is blank' do
      let(:attributes) do
        {
          ark: 'ark:/123/456'
        }
      end

      it 'doesn\'t index the earliest year' do
        expect(solr_document['sort_year_isi']).to eq nil
        expect(solr_document['date_dtsim']).to eq nil
      end
    end

    context 'when normalized_date field is a range' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          normalized_date: ['1934-06/1937-07']
        }
      end

      it 'indexes the earliest year' do
        expect(solr_document['sort_year_isi']).to eq 1934
        expect(solr_document['date_dtsim']).to eq [Date.strptime('1934-06', "%Y-%m").to_time.utc.iso8601, Date.strptime('1937-07', "%Y-%m").to_time.utc.iso8601]
      end
    end

    context 'when normalized_date field is a range of year-month/year-month and one value is invalid' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          normalized_date: ['1934-199/1937-07']
        }
      end

      it 'indexes the correct value' do
        expect(solr_document['date_dtsim']).to eq nil
      end
    end

    context 'when normalized_date field is a range of year/year and both values are invalid' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          normalized_date: ['1944/ff55']
        }
      end

      it 'doesn\'t index the value' do
        expect(solr_document['date_dtsim']).to eq nil
      end
    end

    context 'when normalized_date field is a not a range and value is invalid' do
      let(:attributes) do
        {
          ark: 'ark:/123/456',
          normalized_date: ['1934-199-07']
        }
      end

      it 'doesn\'t index the date' do
        expect(solr_document['date_dtsim']).to eq nil
      end
    end
  end

  describe 'ark' do
    let(:attributes) do
      {
        ark: 'ark:/123/456'
      }
    end

    it 'indexes as a single value "string" without duplicating the prefix ("ark:/ark:/")' do
      expect(solr_document['ark_ssi']).to eq 'ark:/123/456'
    end

    it 'indexes a simplified id for ursus' do
      expect(solr_document['ursus_id_ssi']).to eq '123-456'
    end
  end

  describe 'sort_title' do
    let(:attributes) do
      {
        ark: 'ark:/123/456',
        title: ['Primary title']
      }
    end

    it 'indexs the only value' do
      expect(solr_document['title_alpha_numeric_ssort']).to eq 'Primary title'
    end
  end

  describe '#thumbnail_url' do
    let(:attributes) do
      {
        ark: 'ark:/123/456',
        access_copy: access_copy,
        thumbnail_link: thumbnail_link
      }
    end
    let(:access_copy) { nil }
    let(:thumbnail_link) { nil }

    context 'when thumbnail_link is a iiif resource' do
      let(:thumbnail_link) { 'https://fake.url/iiif/2/id' }

      it 'adds iiif parameters' do
        expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg'
      end

      context 'when it already includes iiif parameters' do
        let(:thumbnail_link) { 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg' }

        it 'does not add them again' do
          expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg'
        end
      end

      context 'when it doesn\'t match the expected format' do
        let(:thumbnail_link) { 'https://fake.url/iiif/2/id/full/!200,200/' }

        it 'returns nil' do
          expect(solr_document['thumbnail_url_ss']).to eq nil
        end
      end
    end

    context 'when thumbnail_link is an image url' do
      let(:thumbnail_link) { 'https://fake.url/id.svg' }

      it 'is indexed as is' do
        expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/id.svg'
      end
    end

    context 'when thumbnail_link is empty' do
      context 'when a iiif resource can be derived from an access copy' do
        let(:access_copy) { 'https://fake.url/iiif/2/id' }

        it 'adds iiif parameters' do
          expect(solr_document['thumbnail_url_ss']).to eq 'https://fake.url/iiif/2/id/full/!200,200/0/default.jpg'
        end
      end

      context 'when access_copy is not a iiif resource' do
        let(:access_copy) { 'https://fake.url/media_stream/id' }

        it 'returns nil' do
          expect(solr_document['thumbnail_url_ss']).to be_nil
        end
      end

      context 'when access_copy is nil' do
        it 'returns nil' do
          expect(solr_document['thumbnail_url_ss']).to be_nil
        end
      end
    end
  end

  describe '#thumbnail_from_access_copy' do
    let(:attributes) do
      {
        ark: 'ark:/123/456',
        access_copy: expected_url
      }
    end
    let(:expected_url) { 'http://fake.server/iiif/2/id' }

    context 'when the work has an image path' do
      it 'uses that image' do
        expect(indexer.thumbnail_from_access_copy).to eq expected_url
      end
    end

    context 'when the work has no image' do
      let(:attributes) do
        {
          ark: 'ark:/123/456'
        }
      end

      it 'asks the document\'s children' do
        child_work = ChildWork.new(ark: 'ark:/abc/xyz', access_copy: expected_url)
        allow(work).to receive(:members).and_return([child_work])
        expect(indexer.thumbnail_from_access_copy).to eq expected_url
      end
    end

    context 'when the document has neither an image path nor children' do
      let(:attributes) do
        {
          ark: 'ark:/123/456'
        }
      end

      it 'returns nil' do
        expect(indexer.thumbnail_from_access_copy).to eq nil
      end
    end
  end
end
