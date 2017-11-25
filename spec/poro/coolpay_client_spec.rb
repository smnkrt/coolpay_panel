require 'rails_helper'

describe CoolpayClient do
  subject { described_class }

  let(:coolpay_config) { Rails.application.secrets.coolpay }
  let(:host)           { coolpay_config[:host] }

  describe '#login_url' do
    let(:login_url) { "#{host}/api/login" }
    it { expect(subject.login_url).to eq(login_url) }
  end

  describe '#recipients_url' do
    let(:recipients_url) { "#{host}/api/recipients" }
    it { expect(subject.recipients_url).to eq(recipients_url) }
  end

  describe '#payments_url' do
    let(:payments_url) { "#{host}/api/payments" }
    it { expect(subject.payments_url).to eq(payments_url) }
  end

  describe '#username' do
    let(:username) { coolpay_config[:username] }
    it { expect(subject.username).to eq(username) }
  end

  describe '#api_key' do
    let(:api_key) { coolpay_config[:api_key] }
    it { expect(subject.api_key).to eq(api_key) }
  end
end
