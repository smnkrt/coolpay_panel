class ApplicationController < ActionController::Base
  before_action :authorize!
  protect_from_forgery with: :exception

  private

  def authorize!
    return if access_token.present? && access_token == params[:token]
    render json: { error: 'resource missing' }, status: 404
  end

  def access_token
    Rails.application.secrets.api_access_token
  end

  def coolpay_token
    Rails.cache.fetch(:coolpay_token, expires_in: 1.minute) do
      API::Login.new.call
    end
  end

  def render_422
    render json: { error: 'unprocessable entity' }, status: 422
  end
end
