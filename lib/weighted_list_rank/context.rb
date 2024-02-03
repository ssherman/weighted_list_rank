module WeightedListRank
  # RankingContext is responsible for applying a ranking strategy to a collection of lists and their items.
  # It aggregates scores for each item across all lists, based on the provided strategy.
  class RankingContext
    # @strategy: The strategy used for calculating scores.
    attr_reader :strategy

    # Initializes a new RankingContext with an optional ranking strategy.
    # @param strategy [Strategy] the strategy to use for ranking items, defaults to Strategies::Exponential.
    def initialize(strategy = Strategies::Exponential.new)
      @strategy = strategy
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
          items[item.id][:list_details] << {list_id: list.id, score: score}

          # Ensure the total_score is initialized, then add the score
          items[item.id][:total_score] ||= 0
          items[item.id][:total_score] += score
        end
      end

      # Convert hash to a sorted array
      sorted_items = items.map do |id, details|
        {
          id: id,
          score_details: details[:list_details],
          total_score: details[:total_score]
        }
      end

      # Sort the array by total_score in descending order
      sorted_items.sort_by { |item| -item[:total_score] }
    end
  end
end
