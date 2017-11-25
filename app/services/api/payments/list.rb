require 'httparty'

module API::Payments
  # INFO: performs a list payments request to Coolpay API
  #       and returns an Array of payment data hashes
  class List
    def initialize(token)
      @token = token
    end

    def call
      JSON.parse(payments_response.body)['payments']
    end

    private

    def payments_response
      HTTParty.get(
        CoolpayClient.payments_url,
        headers: headers
      )
    end

    def headers
      API::Headers::Bearer.new(@token).to_h
    end
  end
end
