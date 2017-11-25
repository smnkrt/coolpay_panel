require 'httparty'

module API::Payments
  # INFO: performs a create payment request to Coolpay API
  #       and returns resource with Coolpay ID
  class Create
    def initialize(token, payment_data)
      @token         = token
      @recipient_id  = payment_data.fetch(:recipient_id)
      @amount        = payment_data.fetch(:amount)
      @currency      = payment_data.fetch(:currency, 'GBP')
    end

    def call
      JSON.parse(crate_payment_response.body)['payment']
    end

    private

    def crate_payment_response
      HTTParty.post(
        CoolpayClient.payments_url,
        body:    body.to_json,
        headers: headers
      )
    end

    def body
      {
        payment: {
          amount:       @amount,
          currency:     @currency,
          recipient_id: @recipient_id
        }
      }
    end

    def headers
      API::Headers::Bearer.new(@token).to_h
    end
  end
end
