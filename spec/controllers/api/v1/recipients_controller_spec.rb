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

    let(:api_create_double) do
      instance_double(API::Recipients::List, call: sample_response)
    end

    before do
      allow(API::Recipients::Create).to receive(:new) { api_create_double }
    end

    context 'with invalid token' do
      let(:token) { 'invalid_token' }
      it_behaves_like '404 with invalid token'
    end

    context 'recipient name missing' do
      let(:create_service_class) { API::Recipients::Create }
      it_behaves_like '422 with invalid params'
    end

    context 'recipient name present' do
      let(:create_service_class)      { API::Recipients::Create }
      let(:create_service_class_args) { [coolpay_token, name] }

      let(:name) { 'sample name' }
      let(:params) { { token: token, name: name } }

      it_behaves_like 'valid params create operation'
    end
  end
end
