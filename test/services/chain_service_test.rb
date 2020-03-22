require 'test_helper'

class ChainServiceTest < ActiveSupport::TestCase
  def setup
    @builder = ChainService.build
  end

  test "first handler succeeds and returns result" do
    b1 = -> { 2*2 }
    b2 = -> { "Ruby" }
    assert_equal b1.call, create_chain(b1, b2).call!
  end

  test "second handler succeeds and returns result" do
    b1 = -> { raise "Error" }
    b2 = -> { "Ruby" }
    assert_equal b2.call, create_chain(b1, b2).call!
  end

  test "chain raises last appropriate error due to all handlers errors" do
    b1 = -> { raise EOFError }
    b2 = -> { raise IndexError }
    assert_raises(IndexError) { create_chain(b1, b2).call! } # IndexError, EOFError < StandardError
    assert_raises(EOFError) { create_chain(b1, b2, IndexError).call! }
  end

  test "chain raises error because of provided EOFError for chain iteration" do
    b1 = -> { raise "Error" }
    b2 = -> { "Ruby" }
    assert_raises { create_chain(b1, b2, EOFError).call! }
  end

  test "chain handles error and returns result from second block" do
    b1 = -> { raise EOFError }
    b2 = -> { "Ruby" }

    chain = create_chain(b1, b2, EOFError)
    assert_equal b2.call, chain.call!

    chain.error_class = StandardError
    assert_equal b2.call, chain.call! # EOFError < StandardError
  end

  # @param [Proc]block1
  # @param [Proc]block2
  # @param [Class<StandardError>]error_class
  # @return [ChainService]
  def create_chain(block1, block2, error_class=StandardError)
    @builder.add_handler(&block1).add_handler(&block2).error(error_class).create
  end
end