class Api::CurrenciesController < ApplicationController
  include LoggerHelper

  def show
    body = @currencies_chain_service.call! params[:id]
    render json: body, status: body.key?('error')? 400: 200
  rescue JSON::ParserError, Faraday::Error => e
    log :error, e
    render json: {error: "Server temporarily is unavailable: #{e.message}"}, status: 503
  end
end