require "minitest/autorun"
require_relative "../../lib/weighted_list_rank" # Adjust the path as necessary

module WeightedListRank
  class TestExponentialStrategy < Minitest::Test
    include Strategies

    def setup
      # Initialize with default exponent
      @strategy = Exponential.new
      @strategy_custom_exponent = Exponential.new(exponent: 2.0)

      @list = MockList.new("List 1", 10, [
        MockItem.new("Item 1", 1),
        MockItem.new("Item 2", 2),
        MockItem.new("Item 3", 3)
      ])
    end

    def test_calculate_score_with_default_exponent
      score_item_1 = @strategy.calculate_score(@list, @list.items.first)
      score_item_2 = @strategy.calculate_score(@list, @list.items[1])

      # Since the score now includes the list's weight as a minimum, adjust the expected values accordingly.
      # The exact expected values will depend on the updated formula in your Exponential class.
      # Below is a placeholder; you need to replace it with the actual expected values based on the calculation.
      expected_score_item_1 = 15.77 # This value needs to be calculated based on your formula
      expected_score_item_2 = 13.14 # This value needs to be calculated based on your formula

      assert_in_delta expected_score_item_1, score_item_1, 0.01
      assert_in_delta expected_score_item_2, score_item_2, 0.01
    end
  end
end
