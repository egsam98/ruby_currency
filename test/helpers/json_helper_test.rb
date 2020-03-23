require 'test_helper'

class JsonHelperTest < ActiveSupport::TestCase
  include JsonHelper

  def setup
    @valid_json = "{\"test\": true}"
    @invalid_json = "{'test': 1}"
    @empty_json = "[]"
  end

  test "valid" do; assert valid? @valid_json end
  test "invalid" do; assert_not valid? @invalid_json end
  test "valid and non empty" do; assert valid_and_not_empty? @valid_json end
  test "valid and empty" do; assert_not valid_and_not_empty? @empty_json end
  test "handle nil" do
    assert_not valid? nil
    assert_not valid_and_not_empty? nil
  end
end