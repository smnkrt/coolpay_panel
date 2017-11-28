require 'controller_spec_helper'

describe Api::V1::PaymentsController, type: :controller do
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
      let(:list_service_class) { API::Payments::List }
      it_behaves_like 'list operation'
    end
  end

  describe 'POST #create' do
    subject { post :create, params: params }

    let(:api_create_double) do
      instance_double(API::Payments::Create, call: sample_response)
    end

    before do
      allow(API::Payments::Create).to receive(:new) { api_create_double }
    end

    context 'invalid payment params' do
      context 'with invalid token' do
        let(:token) { 'invalid_token' }
        it_behaves_like '404 with invalid token'
      end

      context 'with valid token' do
        let(:create_service_class) { API::Payments::Create }
        it_behaves_like '422 with invalid params'
      end
    end

    context 'valid payment params' do
      let(:recipient_id)   { 'abc123' }
      let(:amount)         { 12.20 }
      let(:payment_params) { PaymentParams.new(params) }
      let(:params) do
        { token: token, recipient_id: recipient_id, amount: amount }
      end

      context 'valid recipient_id' do
        let(:create_service_class)      { API::Payments::Create }
        let(:create_service_class_args) { [coolpay_token, payment_params.to_h] }

        it_behaves_like 'valid params create operation'
      end

      context 'invalid recipient_id provided' do
        before do
          allow(api_create_double)
            .to receive(:call)
            .and_raise(API::Payments::Create::RecipientDoesNotExist)
        end

        it 'returns http not found' do
          subject
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'GET #verify' do
    subject { get :verify, params: params }
    let(:params) { { token: token } }

    context 'with invalid token' do
      let(:token) { 'invalid_token' }
      it_behaves_like '404 with invalid token'
    end

    context 'payment id missing' do
      let(:unprocessable_json) { { error: 'unprocessable entity' }.to_json }

      it 'returns http unprocessable entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(unprocessable_json)
      end

      it 'does not call API::Login and API::Recipients::Create' do
        expect(API::Login).not_to receive(:new)
        expect(API::Payments::Verify).not_to receive(:new)
        subject
      end
    end

    context 'payment id present' do
      let(:id)     { 'abc123' }
      let(:params) { { token: token, id: id } }

      let(:api_verify_double) do
        instance_double(API::Payments::Verify, call: sample_response)
      end
      
      it 'calls API::Payments::Verify service and returns result' do
        expect(API::Payments::Verify)
          .to receive(:new)
          .with(coolpay_token, params[:id]) { api_verify_double }
        expect(api_verify_double).to receive(:call)

        subject
        expect(response.body).to eq(sample_response.to_json)
      end
    end
  end
end
