module API::Payments
  class Verify
    def initialize(token, payment_id)
      @token      = token
      @payment_id = payment_id
    end

    def call
      {
        status: status,
        success: success?
      }
    end

    private

    def status
      return 'not_found' if payment.nil?
      payment['status']
    end

    def success?
      return false if payment.nil?
      payment['status'] == 'paid'
    end

    def payment
      @payment ||= payments.find { |payment| payment['id'] == @payment_id }
    end

    def payments
      API::Payments::List.new(@token).call
    end
  end
end
