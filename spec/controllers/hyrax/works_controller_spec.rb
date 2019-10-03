# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::WorksController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin) }
  let(:work) { FactoryBot.create(:work) }
  before { sign_in admin_user }
  describe "GET #manifest" do
    it "returns http success" do
      get :manifest, params: { id: work.id, format: 'json' }
      expect(response).to have_http_status(:success)
    end
  end
end
