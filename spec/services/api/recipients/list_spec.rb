require 'api_spec_helper'

describe API::Recipients::List do
  include_context 'api shared bearer headers with token'
  subject { described_class.new(token) }

  let(:request_params) do
    [CoolpayClient.recipients_url, headers: headers]
  end
  let(:recipient_hash) do
    { recipients: [{ 'id' => '1234', 'name' => 'Abc Def' }] }
  end
  let(:httparty_response) do
    instance_double('HTTParty::Response', body: recipient_hash.to_json)
  end

  before do
    allow(HTTParty)
      .to receive(:get)
      .with(*request_params)
      .and_return(httparty_response)
  end

  it 'performs a get request to coolpay api recipients url' do
    expect(HTTParty).to receive(:get).with(*request_params)
    subject.call
  end

  it 'returns a token parsed from API response' do
    expect(subject.call).to eq(recipient_hash[:recipients])
  end
end
