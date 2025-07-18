## [0.6.0] - 2025-06-29
- Added `list_count_penalties` feature to `RankingContext` to allow penalizing items based on the number of lists they appear on. This is useful for de-emphasizing items that are not widely represented across your data.
- The feature accepts a hash mapping list counts to penalty percentages (e.g., `{1 => 0.50, 2 => 0.25}` to penalize items on 1 list by 50% and items on 2 lists by 25%).
- Penalties are applied to the total score after all list scores are aggregated but before sorting.
- This feature is fully backwards compatible and stacks with individual item penalties.
- Updated all dependencies to their latest versions.

## [0.5.3] - 2024-08-22
- Fixed an issue in the `Exponential` strategy where items with positions higher than the total number of items in a list could cause errors. Now, such items are treated as if they were in the last position, and a warning is logged.
- Added a new test case to verify the handling of items with positions exceeding the list size.
- Updated all dependencies to their latest versions.

## [0.5.2] - 2024-08-21
- Fixed an issue in the `Exponential` strategy where `score_penalty` was not being applied to unranked items. Now, `score_penalty` is correctly applied to both ranked and unranked items, ensuring consistent scoring behavior.
- Updated the `Exponential` strategy to prevent unranked items from receiving bonus points if the list contains both ranked and unranked items. In such cases, unranked items will now only receive the base weight of the list, ensuring ranked items are always prioritized.

## [0.5.1] - 2024-08-21
- Updated the `Exponential` strategy to prevent unranked items from receiving bonus points if the list contains both ranked and unranked items. In such cases, unranked items will now only receive the base weight of the list, ensuring ranked items are always prioritized.

## [0.5.0] - 2024-08-21
- Added `average_list_length` feature to the `Exponential` strategy to adjust the bonus pool based on the average number of items across all lists. This helps prevent smaller lists from receiving disproportionately large bonuses.
- Introduced a new configuration option `include_unranked_items` in the `Exponential` strategy. When enabled, unranked items will receive an equal share of the bonus pool, while ranked items will receive an exponential bonus.
- Updated RDoc documentation to explain the new `average_list_length` and `include_unranked_items` options.
- Fixed test cases to correctly calculate expected values when using `average_list_length`.
- Updated all dependencies to their latest versions.


## [0.4.2] - 2024-07-01
- Fixed bug where a score could be set to 0. The lowest a score can be now is 1.

## [0.4.1] - 2024-06-30
- Added `score_penalty` to the list details hash.

## [0.4.0] - 2024-06-26
- Added `score_penalty` feature to allow percentage-based penalties on item scores.
- Updated all dependencies to their latest versions.

## [0.3.1] - 2024-05-26
- Fixed issue with lists with only a single item getting bonus points.

## [0.3.0] - 2024-02-03
- Added `bonus_pool_percentage` feature to `Exponential` strategy.

## [0.2.0] - 2024-02-03
- Refactored the `Exponential` algorithm to only add bonus points out of a pool of 50% of a list's weight.

## [0.1.3] - 2024-02-03
- Sorted the score details by the highest score from each list first.

## [0.1.2] - 2024-02-03
- Added list weight to rank result.

## [0.1.1] - 2024-02-03
- Fixed `Exponential` strategy to just return the list weight if the item has a nil position.

## [0.1.0] - 2024-02-01
- Initial release.
