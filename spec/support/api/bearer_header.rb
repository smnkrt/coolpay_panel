shared_context 'api shared bearer headers with token' do
  let(:token) { '12345' }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end
end
