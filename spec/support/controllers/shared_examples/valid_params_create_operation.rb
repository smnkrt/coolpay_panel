shared_examples 'valid params create operation' do
  it 'returns http created' do
    subject
    expect(response).to have_http_status(:created)
  end

  it 'calls create_service_class service and returns result' do
    expect(create_service_class)
      .to receive(:new)
      .with(*create_service_class_args) { api_create_double }
    expect(api_create_double).to receive(:call)

    subject
    expect(response.body).to eq(sample_response.to_json)
  end
end
