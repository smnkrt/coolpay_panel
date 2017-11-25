require 'httparty'

module API::Recipients
  # INFO: performs a create request to Coolpay API
  #       and returns resource with Coolpay ID
  class Create
    def initialize(token, recipient_name)
      @token          = token
      @recipient_name = recipient_name
    end

    def call
      JSON.parse(craete_recipient_response.body)
    end

    private

    def craete_recipient_response
      HTTParty.post(
        CoolpayClient.recipients_url,
        body:    body.to_json,
        headers: headers
      )
    end

    def body
      { recipient: { name: @recipient_name } }
    end

    def headers
      API::Headers::Bearer.new(@token).to_h
    end
  end
end
