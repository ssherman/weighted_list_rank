require "minitest/autorun"
require_relative "../../lib/weighted_list_rank" # Adjust the path as necessary

module WeightedListRank
  class TestExponentialStrategy < Minitest::Test
    include Strategies

    def setup
      # Initialize with default exponent
      @strategy = Exponential.new
      @strategy_custom_exponent = Exponential.new(exponent: 2.0)

      # Setup lists with and without item positions
      @list_with_positions = MockList.new("List 1", 10, [
        MockItem.new("Item 1", 1),
        MockItem.new("Item 2", 2),
        MockItem.new("Item 3", 3)
      ])
      @list_with_nil_position = MockList.new("List 2", 15, [
        MockItem.new("Item 4", nil) # Item with nil position
      ])
    end

    def test_calculate_score_with_default_exponent
      score_item_1 = @strategy.calculate_score(@list_with_positions, @list_with_positions.items.first)
      score_item_2 = @strategy.calculate_score(@list_with_positions, @list_with_positions.items[1])

      expected_score_item_1 = 15.77 # Adjust based on your formula
      expected_score_item_2 = 13.14 # Adjust based on your formula

      assert_in_delta expected_score_item_1, score_item_1, 0.01
      assert_in_delta expected_score_item_2, score_item_2, 0.01
    end

    def test_calculate_score_with_nil_position
      score_item_4 = @strategy.calculate_score(@list_with_nil_position, @list_with_nil_position.items.first)

      assert_equal 15, score_item_4, "Score should equal list weight for items with nil position"
    end
  end
end
