require 'test_helper'

class CurrenciesControllerTest < ActionDispatch::IntegrationTest
  include JsonHelper

  test "200 on right currency" do
    get currency_url "USD"
    assert_response :success
  end

  test "400 on wrong currency" do
    get currency_url "USA"
    assert_response :bad_request
  end

  test "503 on services problems" do
    ExchangeRatesApiService::BASE_URL += "xz"
    FixerApiService::BASE_URL += "xz"
    get currency_url "USD"
    assert_response :service_unavailable
  end

  test "non-empty json body" do
    get currency_url "RUB"
    assert valid_and_not_empty? @response.body

    get currency_url "R"
    assert valid_and_not_empty? @response.body
  end
end
