module WeightedListRank
  module Strategies
    class Exponential < WeightedListRank::Strategy
      attr_reader :exponent

      # Initializes a new instance of the Exponential strategy with an optional exponent.
      # @param exponent [Float] the exponent to use in the score calculation formula, defaults to 1.5.
      def initialize(exponent: 1.5)
        @exponent = exponent
      end

      # Calculates the score of an item within a list based on its rank position, the total number of items,
      # and the list's weight, using an exponential formula.
      # The bonus pool is set to 50% of the list's weight.
      #
      # @param list [WeightedListRank::List] the list containing the item being scored.
      # @param item [WeightedListRank::Item] the item for which to calculate the score.
      #
      # @return [Float] the calculated score for the item, adjusted by the list's weight and the specified exponent.
      def calculate_score(list, item)
        # Return the list weight if there are no positions
        return list.weight if item.position.nil?

        num_items = list.items.count
        total_bonus_pool = list.weight * 0.5  # Bonus pool is 50% of the list's weight

        # Calculate the exponential factor for the item's rank position
        exponential_factor = (num_items + 1 - item.position)**exponent
        total_exponential_factor = (1..num_items).sum { |pos| (num_items + 1 - pos)**exponent }

        # Allocate a portion of the total bonus pool based on the item's exponential factor
        item_bonus = (exponential_factor / total_exponential_factor) * total_bonus_pool

        # The final score is the list's weight plus the item's allocated bonus
        list.weight + item_bonus
      end
    end
  end
end
