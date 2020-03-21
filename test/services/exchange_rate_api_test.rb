require 'test_helper'
require 'exchange_rates_api'
require 'validation_helper'

class ExchangeRateApiTest < ActiveSupport::TestCase
  def setup
    @api = ExchangeRatesApi.new
  end

  test "raise error on base length != 3" do
    check_for_error "US"
  end

  test "raise error on base lower case" do
    check_for_error "rub"
  end

  test "raise error on base not string" do
    check_for_error 23
    check_for_error Hash.new
    check_for_error nil
  end

  private def check_for_error(value)
    assert_raises ValidationHelper::ValidationError do
      @api.get_currency value
    end
  end
end