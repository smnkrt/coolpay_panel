module API::Payments
  class Verify
    def initialize(token, payment_id)
      @token      = token
      @payment_id = payment_id
    end

    def status
      return 'not_found' if payment.nil?
      payment['status']
    end

    def successful?
      return false if payment.nil?
      payment['status'] == 'paid'
    end

    private

    def payment
      @payment ||= payments.find { |payment| payment['id'] == @payment_id }
    end

    def payments
      API::Payments::List.new(@token).call
    end
  end
end
