module WeightedListRank
  module List
    # Returns the weight of the list. Must be implemented by including class.
    # @return [Numeric] the weight of the list
    def weight
      raise NotImplementedError, "Implement this method to return the list's weight"
    end

    # Returns an enumerable collection of items in the list. Must be implemented by including class.
    # @return [Enumerable<Item>] the items within the list
    def items
      raise NotImplementedError, "Implement this method to return the enumerable collection of items"
    end

    # Returns the unique identifier of the list. Must be implemented by including class.
    # @return [Integer, String] the unique identifier of the list
    def id
      raise NotImplementedError, "Implement this method to return the unique identifier of a list"
    end
  end
end
