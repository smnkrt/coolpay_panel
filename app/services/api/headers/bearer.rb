module API::Headers
  class Bearer
    def initialize(token)
      @token = token
    end

    def to_h
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@token}"
      }
    end
  end
end
