require 'rails_helper'

describe Api::V1::PaymentsController, type: :controller do
  # TODO: application controller auth shared specs
  # TODO: shared specs to extract common spec logic and improve readability

  let(:token)  { Rails.application.secrets.api_access_token }
  let(:params) { { token: token } }
  let(:coolpay_token) { 'coolpay_token' }

  let(:sample_response)    { { date: 'somedata' } }
  let(:unprocessable_json) { { error: 'unprocessable entity' }.to_json }

  before do
    allow_any_instance_of(API::Login).to receive(:call) { coolpay_token }
  end

  describe 'GET #list' do
    let(:api_payments_list) do
      instance_double(API::Payments::List, call: sample_response)
    end

    before do
      allow(API::Payments::List).to receive(:new) { api_payments_list }
    end

    subject { get :list, params: params }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'calls API::Payments::List service and returns result' do
      expect(API::Payments::List)
        .to receive(:new)
          .with(coolpay_token) { api_payments_list }
      expect(api_payments_list).to receive(:call)

      subject
      expect(response.body).to eq(sample_response.to_json)
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
      before do

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

      context 'valid recipiend_id' do
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
