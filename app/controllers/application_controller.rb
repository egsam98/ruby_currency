require_relative '../helpers/validation_helper'


class ApplicationController < ActionController::Base
  rescue_from ValidationHelper::ValidationError, with: :handle_validation_err

  # @param [ValidationHelper::ValidationError] e
  def handle_validation_err(e)
    render json: {error: e.errors}, status: 400
  end
end
