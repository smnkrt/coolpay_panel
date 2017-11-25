class Api::V1::RecipientsController < ApplicationController
  before_action :validate_params!, only: :create

  def create
    response = API::Recipients::Create.new(coolpay_token, params[:name]).call
    render json: response.to_json, status: 201
  end

  def list
    response = API::Recipients::List.new(coolpay_token).call
    render json: response.to_json, status: 200
  end

  private

  def validate_params!
    return if params[:name].present?
    render_422
  end
end
