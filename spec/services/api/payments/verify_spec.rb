require 'api_spec_helper'

describe API::Payments::Verify do
  subject { described_class.new(token, payment_id) }
  let(:token) { '123' }

  let(:payment_list) do
    [
      {
        'status'       => 'paid',
        'recipient_id' => 'r1',
        'id'           => 'p1',
        'currency'     => 'GBP',
        'amount'       => '10.9'
      },
      {
        'status'       => 'failed',
        'recipient_id' => 'r2',
        'id'           => 'p2',
        'currency'     => 'GBP',
        'amount'       => '10.9'
      },
      {
        'status'       => 'processing',
        'recipient_id' => 'r3',
        'id'           => 'p3',
        'currency'     => 'GBP',
        'amount'       => '10.9'
      }
    ]
  end

  before do
    list_double = instance_double('API::Payments::List', call: payment_list)
    allow(API::Payments::List)
      .to receive(:new)
      .with(token) { list_double }
  end

  let(:expected_hash) do
    { status: status, success: success }
  end

  context 'payment is being processed' do
    let(:payment_id) { 'p3' }
    let(:status)     { 'processing' }
    let(:success)    { false }
    it { expect(subject.call).to eq(expected_hash) }
  end

  context 'payment failed' do
    let(:payment_id) { 'p2' }
    let(:status)     { 'failed' }
    let(:success)    { false }
    it { expect(subject.call).to eq(expected_hash) }
  end

  context 'payment is paid' do
    let(:payment_id) { 'p1' }
    let(:status)     { 'paid' }
    let(:success)    { true }
    it { expect(subject.call).to eq(expected_hash) }
  end

  context 'payment is missing' do
    let(:payment_id) { 'p4' }
    let(:status)     { 'not_found' }
    let(:success)    { false }
    it { expect(subject.call).to eq(expected_hash) }
  end
end
