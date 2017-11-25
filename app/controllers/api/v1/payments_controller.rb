class Api::V1::PaymentsController < ApplicationController
  before_action :validate_price_params!, only: :create
  before_action :validate_price_id!, only: :verify

  def create
    response = API::Payments::Create.new(coolpay_token, payment_params.to_h).call
    render json: response.to_json, status: 201
  rescue API::Payments::Create::RecipientDoesNotExist
    render_404
  end

  def verify
    response = API::Payments::Verify.new(coolpay_token, payment_params.to_h).call
    render json: response.to_json, status: 200
  end

  def list
    response = API::Payments::List.new(coolpay_token).call
    render json: response.to_json, status: 200
  end

  private

  def validate_price_params!
    render_422 unless payment_params.valid?
  end

  def validate_price_id!
    render_422 if params[:id].blank?
  end

  def payment_params
    @payment_params ||= PaymentParams.new(params)
  end
end
