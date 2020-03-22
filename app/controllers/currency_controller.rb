
class CurrencyController < ApplicationController

  def show
    chain = ChainService.build
        .add_handler { ExchangeRatesApiService.new.get_currency! params[:id] }
        .add_handler { FixerApiService.new.get_currency! }
        .error(Faraday::ConnectionFailed)
        .create
    render json: chain.call!
  rescue JSON::ParserError, Faraday::ConnectionFailed => e
    render json: {error: "Server temporarily is unavailable: #{e.message}"}, status: 503
  end
end
