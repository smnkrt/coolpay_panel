class PaymentParams
  def initialize(payment_params)
    @payment_params = payment_params
  end

  def to_h
    return {} unless valid?
    {
      recipient_id: @payment_params[:recipient_id],
      amount:       Float(@payment_params[:amount])
    }
  end

  def valid?
    @payment_params[:recipient_id].present? &&
      @payment_params[:amount].present?
  end
end
