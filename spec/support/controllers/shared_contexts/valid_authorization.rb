shared_context 'api valid authorization' do
  let(:token)  { Rails.application.secrets.api_access_token }

  let(:coolpay_token) { 'coolpay_token' }

  before do
    allow_any_instance_of(API::Login).to receive(:call) { coolpay_token }
  end
end
