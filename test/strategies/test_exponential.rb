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
      @list_with_one_item = MockList.new("List 3", 20, [
        MockItem.new("Item 5", 1) # Only one item in the list
      ])

      # Setup lists with score penalties
      @list_with_penalties = MockList.new("List 4", 10, [
        MockItem.new("Item 6", 1, 0.20), # 20% penalty
        MockItem.new("Item 7", 2, 0.10), # 10% penalty
        MockItem.new("Item 8", 3, nil)   # No penalty
      ])
      @list_with_penalty_and_nil_position = MockList.new("List 5", 15, [
        MockItem.new("Item 9", nil, 0.15) # 15% penalty and nil position
      ])
    end

    def test_calculate_score_with_default_exponent
      score_item_1 = @strategy.calculate_score(@list_with_positions, @list_with_positions.items.first)
      score_item_2 = @strategy.calculate_score(@list_with_positions, @list_with_positions.items[1])

      expected_score_item_1 = 15.75
      expected_score_item_2 = 13.13

      assert_in_delta expected_score_item_1, score_item_1, 0.01
      assert_in_delta expected_score_item_2, score_item_2, 0.01
    end

    def test_calculate_score_with_nil_position
      score_item_4 = @strategy.calculate_score(@list_with_nil_position, @list_with_nil_position.items.first)

      assert_equal 15, score_item_4, "Score should equal list weight for items with nil position"
    end

    def test_calculate_score_with_one_item
      score_item_5 = @strategy.calculate_score(@list_with_one_item, @list_with_one_item.items.first)

      assert_equal 20, score_item_5, "Score should equal list weight for lists with only one item"
    end

    def test_calculate_score_with_penalties
      score_item_6 = @strategy.calculate_score(@list_with_penalties, @list_with_penalties.items.first)
      score_item_7 = @strategy.calculate_score(@list_with_penalties, @list_with_penalties.items[1])
      score_item_8 = @strategy.calculate_score(@list_with_penalties, @list_with_penalties.items[2])

      expected_score_item_6 = 15.75 * 0.80 # 20% penalty
      expected_score_item_7 = 13.13 * 0.90 # 10% penalty
      expected_score_item_8 = 11.10

      assert_in_delta expected_score_item_6, score_item_6, 0.01
      assert_in_delta expected_score_item_7, score_item_7, 0.01
      assert_in_delta expected_score_item_8, score_item_8, 0.01
    end

    def test_calculate_score_with_penalty_and_nil_position
      score_item_9 = @strategy.calculate_score(@list_with_penalty_and_nil_position, @list_with_penalty_and_nil_position.items.first)

      expected_score_item_9 = 15 * 0.85 # 15% penalty

      assert_in_delta expected_score_item_9, score_item_9, 0.01
    end

    def test_calculate_score_with_minimum_floor
      list_with_low_scores = MockList.new("List 6", 1, [
        MockItem.new("Item 10", 1, 0.99), # 99% penalty
        MockItem.new("Item 11", 2, 0.99)  # 99% penalty
      ])

      score_item_10 = @strategy.calculate_score(list_with_low_scores, list_with_low_scores.items.first)
      score_item_11 = @strategy.calculate_score(list_with_low_scores, list_with_low_scores.items[1])

      # Ensure the score is not less than 1
      assert_equal 1, score_item_10, "Score should not be less than 1 even with high penalties"
      assert_equal 1, score_item_11, "Score should not be less than 1 even with high penalties"
    end
  end
end
