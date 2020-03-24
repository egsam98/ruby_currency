require 'validation_helper'


class ApplicationController < ActionController::Base
  include StringHelper

  protect_from_forgery with: :null_session
  rescue_from ValidationHelper::ValidationError, with: :handle_validation_err

  # @param [ValidationHelper::ValidationError] e
  def handle_validation_err(e)
    err_msg = e.errors.map { |k, messages| "#{k.capitalize}: #{messages.map { |x| uncapitalize x }.join(', ')}"}
                  .join('. ')
    render json: {error: err_msg}, status: 400
  end

  def routing_error
    render json: {error: "No route matches [#{request.method}] /#{params[:path]}"}, status: 404
  end
end
