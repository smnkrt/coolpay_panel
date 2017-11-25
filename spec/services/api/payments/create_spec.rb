require 'api_spec_helper'

describe API::Payments::Create do
  include_context 'api shared bearer headers with token'

  subject { described_class.new(token, payment_data) }

  let(:payment_data) do
    {
      amount:       10.5,
      currency:     'GBP',
      recipient_id: '6e7b146e-5957-11e6-8b77-86f30ca893d3'
    }.with_indifferent_access
  end

  let(:body) { { payment: payment_data } }
  let(:request_params) do
    [CoolpayClient.payments_url, body: body.to_json, headers: headers]
  end

  let(:payment_hash) do
    appended_fields = { id: '31db334f-9ac0-42cb-804b-09b2f899d4d2', status: 'processing' }
    { payment: payment_data.merge(appended_fields) }
  end

  let(:httparty_response) do
    instance_double('HTTParty::Response', body: payment_hash.to_json, code: code)
  end
  let(:code) { 200 }

  before do
    allow(HTTParty)
      .to receive(:post)
      .with(*request_params)
      .and_return(httparty_response)
  end

  it 'performs a post request to coolpay api recipients url' do
    expect(HTTParty).to receive(:post).with(*request_params)
    subject.call
  end

  context 'response code 200' do
    it 'returns a token parsed from API response' do
      expect(subject.call).to eq(payment_hash[:payment])
    end
  end

  context 'response code 422' do
    let(:code) { 422 }
    it 'raises RecipientDoesNotExist error' do
      expect { subject.call }.to raise_error(API::Payments::Create::RecipientDoesNotExist)
    end
  end
end
