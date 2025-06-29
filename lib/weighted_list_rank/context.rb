module WeightedListRank
  # RankingContext is responsible for applying a ranking strategy to a collection of lists and their items.
  # It aggregates scores for each item across all lists, based on the provided strategy.
  class RankingContext
    # @strategy: The strategy used for calculating scores.
    # @list_count_penalties: Hash mapping list counts to penalty percentages (e.g., {1 => 0.50, 2 => 0.25})
    attr_reader :strategy, :list_count_penalties

    # Initializes a new RankingContext with an optional ranking strategy and list count penalties.
    # @param strategy [Strategy] the strategy to use for ranking items, defaults to Strategies::Exponential.
    # @param list_count_penalties [Hash] hash mapping list counts to penalty percentages, defaults to empty hash.
    def initialize(strategy = Strategies::Exponential.new, list_count_penalties: {})
      @strategy = strategy
      @list_count_penalties = list_count_penalties
    end

    # Ranks items across multiple lists according to the strategy's score calculation.
    # @param lists [Array<List>] an array of List objects to be ranked.
    # @return [Array<Hash>] a sorted array of item scores, with each item's details including ID, score details, and total score.
    def rank(lists)
      items = {}
      lists.each do |list|
        list.items.each do |item|
          score = strategy.calculate_score(list, item)
          items[item.id] ||= {}
          # Ensure the list_details array exists, then append the new score detail
          items[item.id][:list_details] ||= []
          items[item.id][:list_details] << {list_id: list.id, score: score, weight: list.weight, score_penalty: item.score_penalty}

          # Ensure the total_score is initialized, then add the score
          items[item.id][:total_score] ||= 0
          items[item.id][:total_score] += score
        end
      end

      # Convert hash to a formatted array
      formatted_items = items.map do |id, details|
        {
          id: id,
          # Sort the score_details array by score in descending order before including it
          score_details: details[:list_details].sort_by { |detail| -detail[:score] },
          total_score: details[:total_score]
        }
      end

      # Apply list count penalties if configured
      if !list_count_penalties.empty?
        formatted_items.each do |item|
          list_count = item[:score_details].length
          if (penalty = list_count_penalties[list_count])
            item[:total_score] *= (1 - penalty)
          end
        end
      end

      # Sort the array by total_score in descending order
      formatted_items.sort_by { |item| -item[:total_score] }
    end
  end
end
