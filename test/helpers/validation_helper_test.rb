require 'test_helper'
require 'validation_helper'


class ValidationHelperTest < ActiveSupport::TestCase
  class ContractTest < ValidationHelper::Contract
    schema { required(:age).value(:integer) }
    rule(:age) { key.failure("Must be 18+ years old") if value < 18 }
  end

  def setup
    @contract_test = ContractTest.new
  end

  test "raise exception on validation_error" do
    assert_raises(ValidationHelper::ValidationError) { @contract_test.call! no_age: 1 }
  end

  test "raise nothing" do
    assert_nothing_raised { @contract_test.call! age: 18 }
  end

  test "has provided value" do
    age = 17
    @contract_test.call! age: age
  rescue ValidationHelper::ValidationError => e
    assert_match /^.+, provided: #{age}$/, e.errors[:age].first
  end
end