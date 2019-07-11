# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::WorkForm do
  let(:form) { described_class.new(Work.new, {}, {}) }

  it 'has all the custom terms' do
    expect(form.terms).to include(
      :alternative_title,
      :architect,
      :caption,
      :dimensions,
      :extent,
      :funding_note,
      :genre,
      :latitude,
      :local_identifier,
      :longitude,
      :master_file_path,
      :medium,
      :named_subject,
      :normalized_date,
      :photographer,
      :place_of_origin,
      :repository,
      :rights_country,
      :rights_holder,
      :support,
      :uniform_title
    )
  end
end
