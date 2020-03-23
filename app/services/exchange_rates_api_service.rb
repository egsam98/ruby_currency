require 'json'
require 'validation_helper'


class ExchangeRatesApiService
  BASE_URL = Settings[:exchange_rates_api][:base_url]

  class Contract < ValidationHelper::Contract
    schema { required(:base).value(:string) }
    rule(:base) { key.failure('Must be a currency code') unless /[A-Z]{3}/.match value }
  end

  # @param [String]base "USD" default
  # @raise [JSON::ParserError, Faraday::ConnectionFailed, ValidationHelper::ValidationError]
  # @return [Hash]
  def get_currency!(base='USD')
    params = {base: base}
    Contract.new.call! params
    raw_body = Faraday.new(url: BASE_URL, params: params).get('/latest').body
    JSON.parse raw_body
  end
end