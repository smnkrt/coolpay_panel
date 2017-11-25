require 'httparty'

module API
  # INFO: performs a login request to Coolpay API
  #       and returns token from API response
  class Login
    def call
      JSON.parse(login_response.body)['token']
    end

    private

    def login_response
      HTTParty.post(
        CoolpayClient.login_url,
        body:    body.to_json,
        headers: headers
      )
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def body
      {
        username: CoolpayClient.username,
        apikey:   CoolpayClient.api_key
      }
    end
  end
end
