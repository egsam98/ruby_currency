require 'test_helper'

class StringHelperTest < ActiveSupport::TestCase
  include StringHelper

  test "uncapitalize success" do
    input = "Test"
    output = "test"
    assert_equal output, uncapitalize(input)
  end

  test "handle nil" do
    assert_nil uncapitalize nil
  end
end