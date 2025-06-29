# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "weighted_list_rank"
require "minitest/autorun"

module WeightedListRank
  class MockStrategy < Strategy
    def calculate_score(list, item)
      # Simple mock calculation based on item position
      score = list.weight * (1.0 / item.position)

      # Apply score penalty if it exists, similar to Exponential strategy
      score = apply_penalty(score, item.score_penalty)

      # Ensure the score is not less than 1
      [score, 1].max
    end

    private

    def apply_penalty(score, penalty)
      penalty ? score * (1 - penalty) : score
    end
  end

  class MockList
    include List
    attr_reader :weight, :id, :items

    def initialize(id, weight, items)
      @id = id
      @weight = weight
      @items = items
    end
  end

  class MockItem
    include Item
    attr_reader :id, :position, :score_penalty

    def initialize(id, position, score_penalty = nil)
      @id = id
      @position = position
      @score_penalty = score_penalty
    end
  end
end
