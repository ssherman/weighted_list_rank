module WeightedListRank
  module Strategies
    # The Exponential strategy calculates the score of an item within a list using an exponential formula.
    # This strategy emphasizes the significance of an item's rank within the list, where items with higher
    # ranks (closer to 1) are exponentially more valuable than those with lower ranks. The magnitude of the bonus
    # applied to each item's score is determined by the bonus pool percentage of the list's total weight.
    #
    # The exponential nature of the calculation is controlled by the +exponent+ attribute, allowing for
    # flexible adjustment of how steeply the score decreases as rank increases. The +bonus_pool_percentage+
    # attribute determines the size of the bonus pool as a percentage of the list's total weight, allowing
    # customization of the bonus impact on the final scores.
    class Exponential < WeightedListRank::Strategy
      # The exponent used in the score calculation formula. Higher values increase the rate at which
      # scores decrease as item rank increases.
      #
      # @return [Float] the exponent value
      attr_reader :exponent

      # The percentage of the list's total weight that constitutes the bonus pool. This value determines
      # how the total bonus pool is calculated as a percentage of the list's weight.
      #
      # @return [Float] the bonus pool percentage, defaulting to 1.0 (100% of the list's weight).
      attr_reader :bonus_pool_percentage

      # Initializes a new instance of the Exponential strategy with optional parameters for exponent and
      # bonus pool percentage.
      # @param exponent [Float] the exponent to use in the score calculation formula, defaults to 1.5.
      # @param bonus_pool_percentage [Float] the percentage of the list's weight to be used as the bonus pool,
      # defaults to 1.0 (100%).
      def initialize(exponent: 1.5, bonus_pool_percentage: 1.0)
        @exponent = exponent
        @bonus_pool_percentage = bonus_pool_percentage
      end

      # Calculates the score of an item within a list based on its rank position, the total number of items,
      # and the list's weight, using an exponential formula. The bonus pool for score adjustments is determined
      # by the specified bonus pool percentage of the list's total weight.
      #
      # @param list [WeightedListRank::List] the list containing the item being scored.
      # @param item [WeightedListRank::Item] the item for which to calculate the score.
      #
      # @return [Float] the calculated score for the item, adjusted by the list's weight, the specified exponent,
      # and the bonus pool percentage.
      def calculate_score(list, item)
        # Default score to the list's weight
        score = list.weight

        unless item.position.nil? || list.items.count == 1
          num_items = list.items.count
          total_bonus_pool = list.weight * bonus_pool_percentage

          # Calculate the exponential factor for the item's rank position
          exponential_factor = (num_items + 1 - item.position)**exponent
          total_exponential_factor = (1..num_items).sum { |pos| (num_items + 1 - pos)**exponent }

          # Allocate a portion of the total bonus pool based on the item's exponential factor
          item_bonus = (exponential_factor / total_exponential_factor) * total_bonus_pool

          # Add the item's allocated bonus to the default score
          score += item_bonus
        end

        # Apply score penalty if it exists
        score = apply_penalty(score, item.score_penalty)

        # Ensure the score is not less than 1
        [score, 1].max
      end

      private

      # Applies the score penalty if it exists
      #
      # @param score [Float] the original score of the item
      # @param penalty [Float, NilClass] the score penalty of the item as a percentage (e.g., 0.20 for 20%) or nil if no penalty
      #
      # @return [Float] the score after applying the penalty
      def apply_penalty(score, penalty)
        penalty ? score * (1 - penalty) : score
      end
    end
  end
end
