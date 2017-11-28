shared_examples 'list operation' do

  let(:api_list_double) do
    instance_double(list_service_class, call: sample_response)
  end

  before do
    allow(list_service_class).to receive(:new) { api_list_double }
  end

  it 'returns http success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'calls list_service_class service and returns result' do
    expect(list_service_class)
      .to receive(:new)
      .with(coolpay_token) { api_list_double }
    expect(api_list_double).to receive(:call)

    subject
    expect(response.body).to eq(sample_response.to_json)
  end
end
