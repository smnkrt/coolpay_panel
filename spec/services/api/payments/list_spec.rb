require 'api_spec_helper'

describe API::Payments::List do
  include_context 'api shared bearer headers with token'
  subject { described_class.new(token) }

  let(:request_params) { [CoolpayClient.payments_url, headers: headers] }
  let(:payments_hash) do
    {
      payments: [
        {
          'id'           => '31db334f-9ac0-42cb-804b-09b2f899d4d2',
          'amount'       => '10.50',
          'currency'     => 'GBP',
          'recipient_id' => '6e7b146e-5957-11e6-8b77-86f30ca893d3',
          'status'       => 'paid'
        }
      ]
    }
  end
  let(:httparty_response) do
    instance_double('HTTParty::Response', body: payments_hash.to_json)
  end

  before do
    allow(HTTParty)
      .to receive(:get)
      .with(*request_params)
      .and_return(httparty_response)
  end

  it 'performs a get request to coolpay api payments url' do
    expect(HTTParty).to receive(:get).with(*request_params)
    subject.call
  end

  it 'returns a parsed array of payment hashes' do
    expect(subject.call).to eq(payments_hash[:payments])
  end
end
