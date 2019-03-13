# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BrandingInfoController, type: :controller do
  let(:collection_branding_info) { CollectionBrandingInfo.new(filename: 'test.png', collection_id: '3039530', role: 'banner') }
  describe "GET #show" do
    it "returns http success" do
      collection_branding_info
      get :show, params: { id: '3039530', format: 'json' }
      expect(response).to have_http_status(:success)
    end
  end
end
