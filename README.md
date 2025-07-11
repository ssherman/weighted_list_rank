# WeightedListRank

The WeightedListRank gem is a robust, flexible system designed for ranking items within weighted lists. It leverages scoring algorithms to evaluate and prioritize items based on defined criteria, making it an essential tool for data analysis, recommendation systems, and more. The only algorithm currently is the Exponential strategy, an algorithm that forms the backbone of The Greatest Books (thegreatestbooks.org).

WeightedListRank is built with versatility in mind, accommodating different ranking needs and scenarios. By implementing a strategy pattern, it offers the flexibility to apply various algorithms for item scoring and ranking within lists, each considering the list's weight and item positions. The default Exponential strategy underscores the significance of an item's rank in the list, applying an exponential formula to determine its score, thus ensuring that higher-ranked items receive proportionally greater emphasis.

The system is designed for easy extension, allowing developers to introduce new strategies that cater to specific requirements or experimental approaches.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add weighted_list_rank

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install weighted_list_rank

## Usage

The WeightedListRank system allows for flexible ranking of items within weighted lists using various strategies. Below is how to employ the Exponential strategy for ranking, using text identifiers for better readability.

Defining Items and Lists
You need to define your items and lists to include the required methods from WeightedListRank::Item and WeightedListRank::List interfaces:

```ruby
class MyItem
  include WeightedListRank::Item
  attr_reader :id, :position

  def initialize(id, position)
    @id = id
    @position = position
  end
end

class MyList
  include WeightedListRank::List
  attr_reader :id, :weight, :items

  def initialize(id, weight, items)
    @id = id
    @weight = weight
    @items = items
  end
end
```

### Using the Exponential Strategy
After setting up your items and list, you can apply the Exponential strategy to rank the items. The strategy allows for customization of the exponential rate at which scores decrease according to rank.

```ruby
require 'weighted_list_rank'

# Initialize items and list with text identifiers
items = [
  MyItem.new("Item 1", 1),
  MyItem.new("Item 2", 2),
  MyItem.new("Item 3", 3)
]
list = MyList.new("List 1", 10, items)

# Initialize the Exponential strategy with an optional exponent
exponential_strategy = WeightedListRank::Strategies::Exponential.new(exponent: 1.5)

# Create a RankingContext using the Exponential strategy
ranking_context = WeightedListRank::RankingContext.new(exponential_strategy)

# Rank the items
ranked_items = ranking_context.rank([list])

# Display the ranked items
ranked_items.each do |item|
  puts "Item: #{item[:id]}, Total Score: #{item[:total_score]}"
end
```

### Customization Example
Adjust the exponent parameter to change how significantly item rank affects the score. A higher exponent increases the disparity between high and low-ranked items.

```ruby
# Customizing the exponent for greater emphasis on higher ranks
custom_strategy = WeightedListRank::Strategies::Exponential.new(exponent: 2.0)

# Ranking with the customized strategy
custom_ranking_context = WeightedListRank::RankingContext.new(custom_strategy)
custom_ranked_items = custom_ranking_context.rank([list])

# Output the results
custom_ranked_items.each do |item|
  puts "Item: #{item[:id]}, Custom Total Score: #{item[:total_score]}"
end
```

### New Features: average_list_length and include_unranked_items
#### average_list_length
The average_list_length setting adjusts the bonus pool based on the typical size of lists across your system. This value can be calculated as the mean or median number of items across all lists. It helps prevent smaller lists from receiving disproportionately large bonuses.

```ruby
# Customizing with average_list_length
strategy_with_avg_length = WeightedListRank::Strategies::Exponential.new(
  exponent: 1.5,
  average_list_length: 50  # Use mean or median list length
)

ranking_context_with_avg = WeightedListRank::RankingContext.new(strategy_with_avg_length)
ranked_items = ranking_context_with_avg.rank([list])

# Output the results
ranked_items.each do |item|
  puts "Item: #{item[:id]}, Total Score: #{item[:total_score]}"
end
```

#### include_unranked_items
The include_unranked_items setting allows you to distribute a portion of the bonus pool to unranked items. Ranked items receive an exponential bonus, while unranked items split the remaining bonus pool evenly. This feature ensures that unranked lists are still valuable and fairly scored.

```ruby
# Including unranked items in the bonus pool
strategy_with_unranked = WeightedListRank::Strategies::Exponential.new(
  exponent: 1.5,
  include_unranked_items: true
)

ranking_context_with_unranked = WeightedListRank::RankingContext.new(strategy_with_unranked)
ranked_items = ranking_context_with_unranked.rank([list])

# Output the results
ranked_items.each do |item|
  puts "Item: #{item[:id]}, Total Score: #{item[:total_score]}"
end
```

### Using Item Penalties
The WeightedListRank system also supports applying penalties to individual items. A penalty is defined as a percentage reduction in the item's score. This feature can be used to de-emphasize certain items based on specific criteria.

To use the penalty feature, include the score_penalty attribute when defining your items:

```ruby
class MyItem
  include WeightedListRank::Item
  attr_reader :id, :position, :score_penalty

  def initialize(id, position, score_penalty = nil)
    @id = id
    @position = position
    @score_penalty = score_penalty
  end
end
```

You can then apply the penalties when calculating the scores:

```ruby
require 'weighted_list_rank'

# Initialize items and list with text identifiers and penalties
items = [
  MyItem.new("Item 1", 1, 0.20), # 20% penalty
  MyItem.new("Item 2", 2, 0.10), # 10% penalty
  MyItem.new("Item 3", 3, nil)   # No penalty
]
list = MyList.new("List 1", 10, items)

# Initialize the Exponential strategy with an optional exponent
exponential_strategy = WeightedListRank::Strategies::Exponential.new(exponent: 1.5)

# Create a RankingContext using the Exponential strategy
ranking_context = WeightedListRank::RankingContext.new(exponential_strategy)

# Rank the items
ranked_items = ranking_context.rank([list])

# Display the ranked items
ranked_items.each do |item|
  puts "Item: #{item[:id]}, Total Score: #{item[:total_score]}"
end
```

### Customizing Penalties Example
You can customize the penalty values to see how they affect the final scores of the items.

```ruby
# Customizing penalties for different items
items = [
  MyItem.new("Item 1", 1, 0.30), # 30% penalty
  MyItem.new("Item 2", 2, 0.15), # 15% penalty
  MyItem.new("Item 3", 3, nil)   # No penalty
]
list = MyList.new("List 1", 10, items)

# Initialize the Exponential strategy with an optional exponent
exponential_strategy = WeightedListRank::Strategies::Exponential.new(exponent: 2.0)

# Create a RankingContext using the Exponential strategy
ranking_context = WeightedListRank::RankingContext.new(exponential_strategy)

# Rank the items
ranked_items = ranking_context.rank([list])

# Output the results
ranked_items.each do |item|
  puts "Item: #{item[:id]}, Total Score: #{item[:total_score]}"
end
```

### Penalizing Items by Number of Lists
You can optionally penalize items that appear on only a small number of lists. This is useful for de-emphasizing items that are not widely represented across your data. To use this feature, pass a `list_count_penalties` hash to the `RankingContext` constructor, where the keys are the number of lists and the values are the penalty percentages (as a float between 0 and 1).

For example, to penalize items that appear on only 1 list by 50%, and items on 2 lists by 25%:

```ruby
list_count_penalties = {1 => 0.50, 2 => 0.25}
ranking_context = WeightedListRank::RankingContext.new(
  WeightedListRank::Strategies::Exponential.new,
  list_count_penalties: list_count_penalties
)

ranked_items = ranking_context.rank([list1, list2, list3])
```

- Items that appear on only 1 list will have their total score multiplied by 0.5 (50% penalty).
- Items that appear on only 2 lists will have their total score multiplied by 0.75 (25% penalty).
- Items that appear on more lists will not be penalized unless specified in the hash.

#### How it works
- The penalty is applied to the total score of each item after all list scores are aggregated, but before sorting.
- If an item appears on a number of lists not present in the hash, no penalty is applied.
- This feature is fully backwards compatible: if you do not provide `list_count_penalties`, no penalties are applied.
- This penalty stacks with individual item penalties (e.g., `score_penalty` on an item).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

We're on the lookout for more algorithm strategies and implementations! If you're passionate about data analysis, algorithm design, or simply have ideas for improving item ranking methodologies, WeightedListRank offers a welcoming platform for your contributions. Whether it's enhancing existing strategies, proposing new ones, or optimizing the framework for broader applications, your input can significantly impact the community and the projects relying on this system.

Bug reports and pull requests are welcome on GitHub at https://github.com/ssherman/weighted_list_rank. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ssherman/weighted_list_rank/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WeightedListRank project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ssherman/weighted_list_rank/blob/master/CODE_OF_CONDUCT.md).
