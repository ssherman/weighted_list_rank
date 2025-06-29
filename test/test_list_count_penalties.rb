require "minitest/autorun"
require_relative "test_helper"
require_relative "../lib/weighted_list_rank"

module WeightedListRank
  class TestListCountPenalties < Minitest::Test
    def setup
      @strategy = MockStrategy.new

      # Create test items
      @item1 = MockItem.new("Item 1", 1)
      @item2 = MockItem.new("Item 2", 2)
      @item3 = MockItem.new("Item 3", 1)
      @item4 = MockItem.new("Item 4", 1)

      # Create test lists
      @list1 = MockList.new("List 1", 10, [@item1, @item2])
      @list2 = MockList.new("List 2", 5, [@item1, @item3])
      @list3 = MockList.new("List 3", 15, [@item1, @item2, @item4])
    end

    def test_no_penalties_applied_when_not_configured
      context = RankingContext.new(@strategy)
      result = context.rank([@list1, @list2, @list3])

      # Item 1 appears on 3 lists, Item 2 on 2 lists, Item 3 on 1 list, Item 4 on 1 list
      item1 = result.find { |item| item[:id] == "Item 1" }
      item2 = result.find { |item| item[:id] == "Item 2" }
      item3 = result.find { |item| item[:id] == "Item 3" }
      item4 = result.find { |item| item[:id] == "Item 4" }

      # Without penalties, Item 1 should have the highest score (appears on 3 lists)
      assert_equal "Item 1", result.first[:id]
      assert_equal 3, item1[:score_details].length
      assert_equal 2, item2[:score_details].length
      assert_equal 1, item3[:score_details].length
      assert_equal 1, item4[:score_details].length
    end

    def test_penalties_applied_correctly
      list_count_penalties = {1 => 0.50, 2 => 0.25}
      context = RankingContext.new(@strategy, list_count_penalties: list_count_penalties)
      result = context.rank([@list1, @list2, @list3])

      item1 = result.find { |item| item[:id] == "Item 1" }
      item2 = result.find { |item| item[:id] == "Item 2" }
      item3 = result.find { |item| item[:id] == "Item 3" }
      item4 = result.find { |item| item[:id] == "Item 4" }

      # Item 1: 3 lists, no penalty
      # Item 2: 2 lists, 25% penalty
      # Item 3: 1 list, 50% penalty
      # Item 4: 1 list, 50% penalty

      # Calculate expected scores
      original_score1 = 10.0 + 5.0 + 15.0  # 30.0
      original_score2 = 5.0 + 7.5          # 12.5
      original_score3 = 5.0                # 5.0
      original_score4 = 15.0               # 15.0

      expected_score1 = original_score1     # No penalty
      expected_score2 = original_score2 * 0.75  # 25% penalty
      expected_score3 = original_score3 * 0.5   # 50% penalty
      expected_score4 = original_score4 * 0.5   # 50% penalty

      assert_in_delta expected_score1, item1[:total_score], 0.01
      assert_in_delta expected_score2, item2[:total_score], 0.01
      assert_in_delta expected_score3, item3[:total_score], 0.01
      assert_in_delta expected_score4, item4[:total_score], 0.01
    end

    def test_penalties_affect_ranking_order
      list_count_penalties = {1 => 0.50, 2 => 0.25}
      context = RankingContext.new(@strategy, list_count_penalties: list_count_penalties)
      result = context.rank([@list1, @list2, @list3])

      # With penalties applied, the ranking order should change
      # Item 1: 30.0 (no penalty)
      # Item 2: 12.5 * 0.75 = 9.375 (25% penalty)
      # Item 4: 15.0 * 0.5 = 7.5 (50% penalty)
      # Item 3: 5.0 * 0.5 = 2.5 (50% penalty)

      assert_equal "Item 1", result[0][:id]
      assert_equal "Item 2", result[1][:id]
      assert_equal "Item 4", result[2][:id]
      assert_equal "Item 3", result[3][:id]
    end

    def test_partial_penalty_configuration
      # Only penalize items on 1 list
      list_count_penalties = {1 => 0.30}
      context = RankingContext.new(@strategy, list_count_penalties: list_count_penalties)
      result = context.rank([@list1, @list2, @list3])

      item1 = result.find { |item| item[:id] == "Item 1" }
      item2 = result.find { |item| item[:id] == "Item 2" }
      item3 = result.find { |item| item[:id] == "Item 3" }
      item4 = result.find { |item| item[:id] == "Item 4" }

      # Item 1: 3 lists, no penalty
      # Item 2: 2 lists, no penalty (not configured)
      # Item 3: 1 list, 30% penalty
      # Item 4: 1 list, 30% penalty

      original_score1 = 30.0
      original_score2 = 12.5
      original_score3 = 5.0
      original_score4 = 15.0

      expected_score1 = original_score1     # No penalty
      expected_score2 = original_score2     # No penalty
      expected_score3 = original_score3 * 0.7  # 30% penalty
      expected_score4 = original_score4 * 0.7  # 30% penalty

      assert_in_delta expected_score1, item1[:total_score], 0.01
      assert_in_delta expected_score2, item2[:total_score], 0.01
      assert_in_delta expected_score3, item3[:total_score], 0.01
      assert_in_delta expected_score4, item4[:total_score], 0.01
    end

    def test_empty_penalty_configuration
      list_count_penalties = {}
      context = RankingContext.new(@strategy, list_count_penalties: list_count_penalties)
      result = context.rank([@list1, @list2, @list3])

      # Should behave the same as no penalties configured
      item1 = result.find { |item| item[:id] == "Item 1" }
      item2 = result.find { |item| item[:id] == "Item 2" }

      original_score1 = 30.0
      original_score2 = 12.5

      assert_in_delta original_score1, item1[:total_score], 0.01
      assert_in_delta original_score2, item2[:total_score], 0.01
    end

    def test_penalties_with_individual_item_penalties
      # Create items with individual penalties
      item_with_penalty = MockItem.new("Item 5", 1, 0.20)  # 20% individual penalty
      list_with_individual_penalties = MockList.new("List 4", 20, [item_with_penalty])

      list_count_penalties = {1 => 0.30}
      context = RankingContext.new(@strategy, list_count_penalties: list_count_penalties)
      result = context.rank([list_with_individual_penalties])

      item5 = result.find { |item| item[:id] == "Item 5" }

      # Individual penalty: 20.0 * 0.8 = 16.0
      # List count penalty: 16.0 * 0.7 = 11.2
      expected_score = 20.0 * 0.8 * 0.7

      assert_in_delta expected_score, item5[:total_score], 0.01
    end

    def test_backwards_compatibility
      # Test that the old constructor still works
      context = RankingContext.new(@strategy)
      result = context.rank([@list1, @list2, @list3])

      assert_equal 4, result.size
      assert_equal "Item 1", result.first[:id]
    end

    def test_penalties_with_different_strategies
      exponential_strategy = Strategies::Exponential.new(exponent: 1.5)
      list_count_penalties = {1 => 0.25}

      context = RankingContext.new(exponential_strategy, list_count_penalties: list_count_penalties)
      result = context.rank([@list1])

      # Should work with different strategies
      assert_equal 2, result.size
      assert_equal "Item 1", result.first[:id]
    end
  end
end
