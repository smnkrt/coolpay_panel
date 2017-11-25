require 'api_spec_helper'

describe API::Recipients::Create do
  include_context 'api shared bearer headers with token'

  subject { described_class.new(token, recipient_name) }

  let(:recipient_name) { 'New Recipient'}
  let(:body)           { { recipient: { name: recipient_name } } }
  let(:recipient_hash) do
    { 'recipient' => { 'id' => '123', 'name' => recipient_name } }
  end
  let(:request_params) do
    [CoolpayClient.recipients_url, body: body.to_json, headers: headers]
  end
  let(:httparty_response) do
    instance_double('HTTParty::Response', body: recipient_hash.to_json)
  end

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

  it 'returns a token parsed from API response' do
    expect(subject.call).to eq(recipient_hash)
  end
end
