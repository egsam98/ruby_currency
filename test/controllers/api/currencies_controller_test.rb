require 'test_helper'

class CurrenciesControllerTest < ActionDispatch::IntegrationTest
  include JsonHelper
  include ValidationHelper

  test "200 on right currency" do
    get api_currency_url "USD"
    assert_response :success
  end

  test "400 on wrong currency" do
    get api_currency_url "USA"
    assert_response :bad_request
  end

  test "503 on services problems" do
    ExchangeRatesApiService::BASE_URL += "xz"
    FixerApiService::BASE_URL += "xz"
    get api_currency_url "USD"
    assert_response :service_unavailable
    ExchangeRatesApiService::BASE_URL.delete_suffix! "xz"
    FixerApiService::BASE_URL.delete_suffix! "xz"
  end

  test "non-empty json body" do
    get api_currency_url "RUB"
    assert valid_and_not_empty? @response.body

    get api_currency_url "R"
    assert valid_and_not_empty? @response.body
  end

  test "valid success body" do
    response_contract = Dry::Validation.Contract do
      json do
        optional(:warning).filled(:string)
        required(:base).filled(:string)
        required(:date).filled(:string)
        required(:rates).filled(:hash)
      end

      rule(:base) { key.failure "Must be the currency code" unless /^[A-Z]{3}$/.match value }
      rule(:date) { key.failure "Must be date in format 'yyyy-MM-dd'" unless /^\d{4}-\d{2}-\d{2}$/.match value }
      rule(:rates) {
        is_all_keys_string = value.keys.all?{ |k| k.is_a? String }
        is_all_values_numeric = value.values.all? { |v| v.is_a? Numeric }
        key.failure "Must be hash of currencies (string key and numeric value)" unless is_all_keys_string &&
            is_all_values_numeric
      }
    end

    get api_currency_url "USD"
    body = JSON.parse @response.body
    assert response_contract.call(body).success?
  end

  test "valid error body" do
    response_contract = Dry::Validation.Contract do
      json { required(:error).filled(:string) }
    end

    get api_currency_url "USA"
    body = JSON.parse @response.body
    assert response_contract.call(body).success?
  end
end
