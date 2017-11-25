require 'spec_helper'

describe PaymentParams do
  subject { described_class.new(payment_params) }
  let(:payment_params) { { recipient_id: recipient_id, amount: amount } }
  let(:recipient_id) { 'abc123' }
  let(:amount)       { 10.12 }

  context 'valid params' do
    it { expect(subject.to_h).to eq(payment_params) }
    it { expect(subject.valid?).to eq(true) }
  end

  context 'recipient_id missing' do
    let(:recipient_id) { nil }
    it { expect(subject.to_h).to eq(payment_params) }
    it { expect(subject.valid?).to eq(false) }
  end

  context 'amount missing' do
    let(:amount) { nil }
    it { expect(subject.to_h).to eq(payment_params) }
    it { expect(subject.valid?).to eq(false) }
  end
end
