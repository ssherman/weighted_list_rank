module WeightedListRank
  class Strategy
    # Calculates the score for an item within a list. Must be implemented by subclass.
    # @param list [List] the list containing the item.
    # @param item [Item] the item to calculate the score for.
    # @return [Numeric] the calculated score for the item.
    def calculate_score(list, item)
      raise NotImplementedError
    end
  end
end
