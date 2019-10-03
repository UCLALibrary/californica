# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CsvImportsController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:access_denied_message) { 'Administrator accounts are required to access Californica. Please sign in or create a new account (then ask us to grant it admin privileges)' }

  let(:csv_import) { CsvImport.create!(user: admin_user) }
  let(:valid_attributes) { {} }

  context 'not logged in' do
    describe 'GET #index' do
      before { get :index }

      it 'denies access' do
        expect(flash[:alert]).to eq access_denied_message
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    describe "GET #show" do
      before { get :show, params: { id: csv_import.to_param } }

      it 'denies access' do
        expect(flash[:alert]).to eq access_denied_message
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    describe "GET #new" do
      before { get :new }

      it 'denies access' do
        expect(flash[:alert]).to eq access_denied_message
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    describe "POST #preview" do
      before { post :preview, params: { csv_import: valid_attributes } }

      it 'denies access' do
        expect(flash[:alert]).to eq access_denied_message
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    describe 'GET #log' do
      before { get :log, params: { id: csv_import.to_param } }

      it 'denies access' do
        expect(flash[:alert]).to eq access_denied_message
        expect(response).to redirect_to('/users/sign_in')
      end
    end

    describe "POST #create" do
      it 'denies access' do
        post :create, params: { csv_import: valid_attributes }
        expect(flash[:alert]).to eq access_denied_message
        expect(response).to redirect_to('/users/sign_in')
      end

      it 'doesn\'t create a record' do
        expect do
          post :create, params: { csv_import: valid_attributes }
        end.to change(CsvImport, :count).by(0)
      end
    end
  end

  context 'logged in as non-admin user' do
    before { sign_in user }

    describe 'GET #index' do
      before { get :index }

      it 'denies access' do
        expect(flash[:alert]).to have_content 'Please request admin priviliges or use a different account'
        expect(response).to redirect_to('/users/sign_out')
      end
    end

    describe "GET #show" do
      before { get :show, params: { id: csv_import.to_param } }

      it 'denies access' do
        expect(response).to have_http_status(:found)
      end
    end

    describe "GET #log" do
      before { get :log, params: { id: csv_import.to_param } }

      it 'denies access' do
        expect(flash[:alert]).to have_content 'Please request admin priviliges or use a different account'
        expect(response).to redirect_to('/users/sign_out')
      end
    end

    describe "GET #new" do
      before { get :new }

      it 'denies access' do
        expect(flash[:alert]).to have_content 'Please request admin priviliges or use a different account'
        expect(response).to redirect_to('/users/sign_out')
      end
    end

    describe "POST #preview" do
      it 'denies access' do
        post :preview, params: { csv_import: valid_attributes }
        expect(flash[:alert]).to have_content 'Please request admin priviliges or use a different account'
        expect(response).to redirect_to('/users/sign_out')
      end
    end

    describe "POST #create" do
      it 'denies access' do
        post :create, params: { csv_import: valid_attributes }
        expect(response).to have_http_status(:found)
      end

      it 'doesn\'t create a record' do
        expect do
          post :create, params: { csv_import: valid_attributes }
        end.to change(CsvImport, :count).by(0)
      end
    end
  end

  context 'logged in admin user' do
    before { sign_in admin_user }

    describe 'GET #index' do
      before { get :index }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      before { get :show, params: { id: csv_import.to_param } }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    describe "GET #show.csv" do
      before do
        allow(controller.service).to receive(:csv).and_return('')
        get :show, params: { id: csv_import.to_param, format: :csv }
      end

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      before { get :new }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    describe "GET #log" do
      before { get :log, params: { id: csv_import.to_param } }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    describe 'POST #preview' do
      before { post :preview, params: { csv_import: valid_attributes } }

      it 'displays the preview' do
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new CsvImport' do
          expect do
            post :create, params: { csv_import: valid_attributes }
          end.to change(CsvImport, :count).by(1)
        end

        it 'redirects to the show page for the newly created record' do
          post :create, params: { csv_import: valid_attributes }
          expect(response).to redirect_to(CsvImport.last)
        end

        it 'queues a job to start the import' do
          expect do
            post :create, params: { csv_import: valid_attributes }
          end.to have_enqueued_job(StartCsvImportJob)
        end
      end

      context 'when there is an error' do
        before do
          allow_any_instance_of(CsvImport).to receive(:save).and_return(false)
        end

        it 'doesn\'t create a record' do
          expect do
            post :create, params: { csv_import: {} }
          end.to change(CsvImport, :count).by(0)

          expect(response).to be_successful # renders :new
        end
      end
    end
  end
end
