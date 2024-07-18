# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MastersController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin) }
  before do
    ENV['MASTERS_DIR'] = 'spec/fixtures'
    sign_in admin_user
  end

  describe "GET #download" do
    it "returns http success" do
      get :download, params: { master_file_path: 'images/test.txt' }
      expect(response).to have_http_status(:success)
    end

    context "when 'master_file_path' is a directory" do
      it "returns http not found" do
        expect do
          get :download, params: { master_file_path: 'images' }
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "when 'master_file_path' does not exist" do
      it "returns http not found" do
        expect do
          get :download, params: { master_file_path: 'images/file_that_isnt_there.txt' }
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "when user is not signed in" do
      before { sign_out admin_user }
      it "redirects to login page" do
        get :download, params: { master_file_path: 'images/test.txt' }
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end

  describe "PUT #download" do
    it "returns http not found" do
      expect do
        get :download, params: { master_file_path: 'images/does_not_exist.txt' }
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
