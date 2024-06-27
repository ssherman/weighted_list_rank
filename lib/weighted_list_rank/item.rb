module WeightedListRank
  module Item
    # Returns the position of the item within its list. Must be implemented by including class.
    # @return [Integer] the position of the item
    def position
      raise NotImplementedError, "Implement this method to return the item's position"
    end

    # Returns the unique identifier of the item. Must be implemented by including class.
    # @return [Integer, String] the unique identifier of the item
    def id
      raise NotImplementedError, "Implement this method to return the item's unique identifier"
    end

    # Returns the score penalty of the item. Can be overridden by the including class.
    # @return [Float, NilClass] the score penalty of the item as a percentage (e.g., 0.20 for 20%) or nil if no penalty
    def score_penalty
      nil
    end
  end
end
