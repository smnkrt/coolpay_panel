require 'rails_helper'

describe Api::V1::RecipientsController, type: :controller do
  let(:token)  { Rails.application.secrets.api_access_token }
  let(:params) { { token: token } }
  let(:coolpay_token) { 'coolpay_token' }

  let(:sample_response) { { date: 'somedata' } }

  before do
    allow_any_instance_of(API::Login).to receive(:call) { coolpay_token }
  end

  describe 'GET #list' do
    let(:api_recipients_list) do
      instance_double(API::Recipients::List, call: sample_response)
    end

    before do
      allow(API::Recipients::List).to receive(:new) { api_recipients_list }
    end

    subject { get :list, params: params }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'calls API::Recipients::List service and returns result' do
      expect(API::Recipients::List)
        .to receive(:new)
        .with(coolpay_token) { api_recipients_list }
      expect(api_recipients_list).to receive(:call)

      subject
      expect(response.body).to eq(sample_response.to_json)
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
