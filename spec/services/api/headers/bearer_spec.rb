require 'spec_helper'

describe API::Headers::Bearer do
  subject { described_class.new(token) }
  let(:token) { '1234' }

  describe '#to_h' do
    let(:expected_headers) do
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
      }
    end
    
    it 'generates a hash with headers' do
      expect(subject.to_h).to eq(expected_headers)
    end
  end
end
