require "minitest/autorun"
require_relative "../lib/weighted_list_rank" # Adjust the path as necessary

module WeightedListRank
  class TestRankingContext < Minitest::Test
    def setup
      @strategy = MockStrategy.new
      @items = [MockItem.new("Item 1", 1), MockItem.new("Item 2", 2)]
      @list = MockList.new("List 1", 10, @items)
      @context = RankingContext.new(@strategy)
    end

    def test_rank_single_list
      result = @context.rank([@list])

      assert_equal 2, result.size
      assert_equal "Item 1", result.first[:id]
      assert_equal 10, result.first[:total_score]
      assert_equal "List 1", result.first[:score_details].first[:list_id]
      assert_equal 5, result.last[:total_score]
    end

    def test_rank_multiple_lists
      second_list = MockList.new("List 2", 5, [@items.first, MockItem.new("Item 3", 3)])
      result = @context.rank([@list, second_list])

      assert_equal 3, result.size
      assert_equal 15, result.first[:total_score] # Item 1 total score across lists
    end
  end
end
