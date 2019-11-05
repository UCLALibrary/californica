# frozen_string_literal: true
require 'rails_helper'

# Need to test how code in ApplicationControll affects SessionsController
RSpec.describe Devise::SessionsController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  context 'when user is not logged in' do
    context 'and site is in read-only mode' do
      before { allow(Flipflop).to receive(:read_only?).and_return(true) }

      describe 'GET #sign_in' do
        it 'allows access' do
          get :new
          expect(response).to have_http_status 200
        end
      end
    end
  end
end
