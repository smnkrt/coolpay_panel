class PaymentParams
  def initialize(payment_params)
    @payment_params = payment_params
  end

  def to_h
    @payment_params
  end

  def valid?
    @payment_params[:recipient_id].present? &&
      @payment_params[:amount].present?
  end
end
