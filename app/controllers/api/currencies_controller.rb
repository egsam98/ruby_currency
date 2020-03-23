class Api::CurrenciesController < ApplicationController
  include LoggerHelper

  def show
    chain = ChainService.build
        .add_handler { ExchangeRatesApiService.new.get_currency! params[:id] }
        .add_handler { FixerApiService.new.get_currency! }
        .error(Faraday::ConnectionFailed)
        .create
    body = chain.call!
    render json: body, status: body.key?('error')? 400: 200
  rescue JSON::ParserError, Faraday::Error => e
    log :error, e
    render json: {error: "Server temporarily is unavailable: #{e.message}"}, status: 503
  end
end