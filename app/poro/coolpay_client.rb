class CoolpayClient
  def self.login_url
    "#{coolpay_host}/api/login"
  end

  def self.recipients_url
    "#{coolpay_host}/api/recipients"
  end

  def self.payments_url
    "#{coolpay_host}/api/payments"
  end

  def self.username
    coolpay_config[:username]
  end

  def self.api_key
    coolpay_config[:api_key]
  end

  def self.coolpay_host
    coolpay_config[:host]
  end

  def self.coolpay_config
    Rails.application.secrets.coolpay
  end

  private_class_method :coolpay_config
  private_class_method :coolpay_host
end
