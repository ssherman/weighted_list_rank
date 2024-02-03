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
