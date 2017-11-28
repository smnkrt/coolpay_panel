shared_examples '422 with invalid params' do
  let(:unprocessable_json) { { error: 'unprocessable entity' }.to_json }

  it 'returns http unprocessable entity' do
    subject
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to eq(unprocessable_json)
  end

  it 'does not call API::Login and API::Payments::Create' do
    expect(API::Login).not_to receive(:new)
    expect(create_service_class).not_to receive(:new)
    subject
  end
end
