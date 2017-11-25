require 'rails_helper'

describe API::Authorize do
  let(:headers) do
    { 'Content-Type' => 'application/json' }
  end
  let(:body) do
    { username: CoolpayClient.username, apikey: CoolpayClient.api_key }
  end
  let(:request_params) do
    [CoolpayClient.login_url, body: body.to_json, headers: headers]
  end
  let(:token) { '12345' }
  let(:httparty_response) do
    instance_double('HTTParty::Response', body: "{\"token\":\"#{token}\"}")
  end

  before do
    allow(HTTParty)
      .to receive(:post)
      .with(*request_params)
      .and_return(httparty_response)
  end

  it 'performs a post request to coolpay api login url' do
    expect(HTTParty).to receive(:post).with(*request_params)
    subject.call
  end

  it 'returns a token parsed from API response' do
    expect(subject.call).to eq(token)
  end
end
