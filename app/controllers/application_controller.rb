require_relative '../helpers/validation_helper'


class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from ValidationHelper::ValidationError, with: :handle_validation_err

  # @param [ValidationHelper::ValidationError] e
  def handle_validation_err(e)
    render json: {error: e.errors}, status: 400
  end

  def routing_error
    render json: {error: "No route matches [#{request.method}] /#{params[:path]}"}, status: 404
  end
end
