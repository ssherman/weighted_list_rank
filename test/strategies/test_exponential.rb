require "minitest/autorun"
require_relative "../../lib/weighted_list_rank" # Adjust the path as necessary

module WeightedListRank
  class TestExponentialStrategy < Minitest::Test
    include Strategies

    def setup
      # Initialize with default exponent and a custom average_list_length
      @strategy = Exponential.new
      @strategy_with_avg_length = Exponential.new(average_list_length: 10)
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

      # Add a new list with an item position higher than the total items
      @list_with_high_position = MockList.new("List 7", 10, [
        MockItem.new("Item 12", 1),
        MockItem.new("Item 13", 5)  # This is fine
      ])
      @list_with_high_position.items << MockItem.new("Item 14", 10)  # This is the highest valid position
      @list_with_high_position.items << MockItem.new("Item 15", 20)  # This position is too high
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

      assert_equal 40, score_item_5, "Score should equal list weight + bonus for lists with only one item"
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

    def test_calculate_score_with_average_list_length
      score_item_1 = @strategy_with_avg_length.calculate_score(@list_with_positions, @list_with_positions.items.first)
      score_item_2 = @strategy_with_avg_length.calculate_score(@list_with_positions, @list_with_positions.items[1])

      # The expected scores are based on the corrected calculations
      expected_score_item_1 = 11.727
      expected_score_item_2 = 10.940

      assert_in_delta expected_score_item_1, score_item_1, 0.01
      assert_in_delta expected_score_item_2, score_item_2, 0.01
    end

    def test_calculate_score_with_average_list_length_and_nil_position
      score_item_4 = @strategy_with_avg_length.calculate_score(@list_with_nil_position, @list_with_nil_position.items.first)

      # Even with average_list_length, items with nil position should just get the base weight.
      assert_equal 15, score_item_4, "Score should equal list weight for items with nil position"
    end

    def test_calculate_score_with_position_higher_than_total_items
      # Capture the standard output to check for the warning message
      output = capture_io do
        # Calculate scores for all items, including the one with too high position
        @list_with_high_position.items.each do |item|
          score = @strategy.calculate_score(@list_with_high_position, item)

          # Just assert that we get a numeric score without error
          assert_kind_of Numeric, score, "Expected a numeric score for item with position #{item.position}"
        end
      end

      # Check if the warning message was printed for the item with too high position
      assert_match(/Warning: Item position \(20\) is higher than the total number of items \(4\) in the list. Using total items as position./, output.join)
    end
  end
end
