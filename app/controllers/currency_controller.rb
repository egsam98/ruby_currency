class CurrencyController < ApplicationController
  rescue_from Faraday::ConnectionFailed, Faraday::ServerError, with: :handle_faraday_err

  def show
    res = ExchangeRatesApi.new.get_currency params[:id]
    render json: res
  rescue JSON::ParserError, Faraday::ConnectionFailed
    err_msg = "Server error on #{ExchangeRatesApi::BASE_URL}"
    render json: {error: err_msg}, status: 503
  end
end