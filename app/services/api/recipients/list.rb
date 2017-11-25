require 'httparty'

module API::Recipients
  # INFO: performs a fetch recipients request to Coolpay API
  #       and returns an Array of recipient data hashes
  class List
    def initialize(token)
      @token = token
    end

    def call
      JSON.parse(recipients_response.body)['recipients']
    end

    private

    def recipients_response
      HTTParty.get(
        CoolpayClient.recipients_url,
        headers: headers
      )
    end

    def headers
      API::Headers::Bearer.new(@token).to_h
    end
  end
end
