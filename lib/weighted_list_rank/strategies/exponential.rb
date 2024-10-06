module WeightedListRank
  module Strategies
    class Exponential < WeightedListRank::Strategy
      attr_reader :exponent, :bonus_pool_percentage, :average_list_length, :include_unranked_items

      # Initializes the Exponential strategy with optional parameters for exponent,
      # bonus pool percentage, average list length, and whether to include unranked items in the bonus pool.
      #
      # @param exponent [Float] the exponent to use in the score calculation formula, defaults to 1.5.
      # @param bonus_pool_percentage [Float] the percentage of the list's weight to be used as the bonus pool,
      # defaults to 1.0 (100%).
      # @param average_list_length [Float, NilClass] the average length of lists in the system, either as a mean or median,
      # defaults to nil.
      # @param include_unranked_items [Boolean] whether to include unranked items in the bonus pool calculation,
      # defaults to false for backward compatibility.
      def initialize(exponent: 1.5, bonus_pool_percentage: 1.0, average_list_length: nil, include_unranked_items: false)
        @exponent = exponent
        @bonus_pool_percentage = bonus_pool_percentage
        @average_list_length = average_list_length
        @include_unranked_items = include_unranked_items
      end

      # Calculates the score of an item within a list based on its rank position, the total number of items,
      # and the list's weight, using an exponential formula. The bonus pool for score adjustments is determined
      # by the specified bonus pool percentage of the list's total weight, adjusted by the average list length.
      #
      # If +include_unranked_items+ is true, unranked items will also receive a portion of the bonus pool.
      # Ranked items will receive an exponential bonus, while unranked items will split the remaining bonus pool evenly.
      #
      # @param list [WeightedListRank::List] the list containing the item being scored.
      # @param item [WeightedListRank::Item] the item for which to calculate the score.
      #
      # @return [Float] the calculated score for the item, adjusted by the list's weight, the specified exponent,
      # and the bonus pool percentage.
      def calculate_score(list, item)
        # Default score to the list's weight
        score = list.weight

        # Total number of items in the list
        total_items = list.items.count

        # Separate ranked and unranked items
        ranked_items = list.items.select { |i| i.position }
        num_ranked_items = ranked_items.count

        if num_ranked_items > 0 && item.position.nil?
          # If there are ranked items, unranked items get no bonus, only the list's weight
          score = list.weight
        else
          # Calculate the total bonus pool
          total_bonus_pool = list.weight * bonus_pool_percentage

          # Adjust the bonus pool based on the average list length
          adjusted_bonus_pool = if average_list_length && average_list_length > 0
            total_bonus_pool * (total_items / average_list_length.to_f)
          else
            total_bonus_pool
          end

          if item.position.nil?
            # Unranked items get no bonus if there are ranked items
            if include_unranked_items && num_ranked_items == 0
              unranked_bonus = adjusted_bonus_pool / total_items
              score += unranked_bonus
            end
          else
            # Check if the item's position is higher than the total number of items
            if item.position > total_items
              puts "Warning: Item position (#{item.position}) is higher than the total number of items (#{total_items}) in the list. Using total items as position."
              item_position = total_items
            else
              item_position = item.position
            end

            # Ranked items receive a bonus calculated using the exponential formula
            exponential_factor = (total_items + 1 - item_position)**exponent
            total_exponential_factor = (1..total_items).sum { |pos| (total_items + 1 - pos)**exponent }

            # Allocate a portion of the adjusted bonus pool based on the item's exponential factor
            item_bonus = (exponential_factor / total_exponential_factor) * adjusted_bonus_pool
            score += item_bonus
          end
        end

        # Apply score penalty if it exists, for both ranked and unranked items
        score = apply_penalty(score, item.score_penalty)

        # Ensure the score is not less than 1
        [score, 1].max
      end

      private

      def apply_penalty(score, penalty)
        penalty ? score * (1 - penalty) : score
      end
    end
  end
end
