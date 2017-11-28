shared_examples '404 with invalid token' do
  let(:missing_resource_response) do
    { error: 'resource missing' }.to_json
  end

  it 'returns 404 error' do
    subject
    expect(response.status).to eq(404)
    expect(response.body).to eq(missing_resource_response)
  end
end
