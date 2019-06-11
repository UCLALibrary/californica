# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::WorksController, type: :controller do
  let(:work) { FactoryBot.create(:work) }
  describe "GET #manifest" do
    it "returns http success" do
      work.title = ["Changes"]
      work.date_modified = '09-09-1999'
      work.save!
      get :manifest, params: { id: work.id, format: 'json' }
      expect(response).to have_http_status(:success)
    end
  end
end
