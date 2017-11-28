require 'controller_spec_helper'

describe Api::V1::RecipientsController, type: :controller do
  let(:params) { { token: token } }
  let(:sample_response) { { date: 'somedata' } }

  include_context 'api valid authorization'

  describe 'GET #list' do
    subject { get :list, params: params }

    context 'with invalid token' do
      let(:token) { 'invalid_token' }
      it_behaves_like '404 with invalid token'
    end

    context 'with valid token' do
      let(:list_service_class) { API::Recipients::List }
      it_behaves_like 'list operation'
    end
  end

  describe 'POST #create' do
    subject { post :create, params: params }
    let(:unprocessable_json) { { error: 'unprocessable entity' }.to_json }

    let(:api_recipients_create) do
      instance_double(API::Recipients::List, call: sample_response)
    end

    before do
      allow(API::Recipients::Create).to receive(:new) { api_recipients_create }
    end

    context 'with invalid token' do
      let(:token) { 'invalid_token' }
      it_behaves_like '404 with invalid token'
    end

    context 'recipient name missing' do
      it 'returns http unprocessable entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(unprocessable_json)
      end

      it 'does not call API::Login and API::Recipients::Create' do
        expect(API::Login).not_to receive(:new)
        expect(API::Recipients::Create).not_to receive(:new)
        subject
      end
    end

    context 'recipient name present' do
      let(:name) { 'sample name' }
      let(:params) { { token: token, name: name } }

      it 'returns http created' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'calls API::Recipients::Create service and returns result' do
        expect(API::Recipients::Create)
          .to receive(:new)
          .with(coolpay_token, name) { api_recipients_create }
        expect(api_recipients_create).to receive(:call)

        subject
        expect(response.body).to eq(sample_response.to_json)
      end
    end
  end
end
