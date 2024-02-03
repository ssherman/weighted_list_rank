module WeightedListRank
  module Strategies
    # The Exponential strategy calculates the score of an item within a list using an exponential formula.
    # This strategy emphasizes the significance of an item's rank within the list, where items with higher
    # ranks (closer to 1) are exponentially more valuable than those with lower ranks.
    #
    # The exponential nature of the calculation is controlled by the +exponent+ attribute, allowing for
    # flexible adjustment of how steeply the score decreases as rank increases.
    class Exponential < WeightedListRank::Strategy
      # The exponent used in the score calculation formula. Higher values increase the rate at which
      # scores decrease as item rank increases.
      #
      # @return [Float] the exponent value
      attr_reader :exponent

      # Initializes a new instance of the Exponential strategy with an optional exponent.
      #
      # @param exponent [Float] the exponent to use in the score calculation formula, defaults to 1.5.
      def initialize(exponent: 1.5)
        @exponent = exponent
      end

      # Calculates the score of an item within a list based on its rank position, the total number of items,
      # and the list's weight, using an exponential formula.
      #
      # @param list [WeightedListRank::List] the list containing the item being scored.
      # @param item [WeightedListRank::Item] the item for which to calculate the score.
      #
      # @return [Float] the calculated score for the item, adjusted by the list's weight and the specified exponent.
      def calculate_score(list, item)
        rank_position = item.position

        # if there are no positions, then just return the list weight
        return list.weight if rank_position.nil?

        num_items = list.items.count

        contribution = ((num_items + 1 - rank_position)**exponent) / num_items.to_f
        scaled_contribution = contribution / num_items
        bonus = scaled_contribution * list.weight
        list.weight + bonus
      end
    end
  end
end
