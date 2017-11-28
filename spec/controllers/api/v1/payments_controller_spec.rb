require 'controller_spec_helper'

describe Api::V1::PaymentsController, type: :controller do
  let(:params) { { token: token } }

  let(:sample_response)    { { date: 'somedata' } }
  let(:unprocessable_json) { { error: 'unprocessable entity' }.to_json }

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

    let(:api_payments_create) do
      instance_double(API::Payments::Create, call: sample_response)
    end

    before do
      allow(API::Payments::Create).to receive(:new) { api_payments_create }
    end

    context 'invalid payment params' do
      context 'with invalid token' do
        let(:token) { 'invalid_token' }
        it_behaves_like '404 with invalid token'
      end

      it 'returns http unprocessable entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(unprocessable_json)
      end

      it 'does not call API::Login and API::Payments::Create' do
        expect(API::Login).not_to receive(:new)
        expect(API::Payments::Create).not_to receive(:new)
        subject
      end
    end

    context 'valid payment params' do
      let(:recipient_id) { 'abc123' }
      let(:amount)       { 12.20 }
      let(:params) { { token: token, recipient_id: recipient_id, amount: amount } }
      let(:payment_params) { PaymentParams.new(params) }

      context 'valid recipient_id' do
        it 'returns http created' do
          subject
          expect(response).to have_http_status(:created)
        end

        it 'calls API::Payments::Create service and returns result' do
          expect(API::Payments::Create)
            .to receive(:new)
            .with(coolpay_token, payment_params.to_h) { api_payments_create }
          expect(api_payments_create).to receive(:call)

          subject
          expect(response.body).to eq(sample_response.to_json)
        end
      end

      context 'invalid recipient_id provided' do
        before do
          allow(api_payments_create)
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
      let(:id) { 'abc123' }
      let(:params) { { token: token, id: id } }

      let(:api_payments_verify) do
        instance_double(API::Payments::Verify, call: sample_response)
      end
      it 'calls API::Payments::Verify service and returns result' do
        expect(API::Payments::Verify)
          .to receive(:new)
          .with(coolpay_token, params[:id]) { api_payments_verify }
        expect(api_payments_verify).to receive(:call)

        subject
        expect(response.body).to eq(sample_response.to_json)
      end
    end
  end
end
