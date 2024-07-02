## [Unreleased]

## [0.4.2] - 2024-07-01
- fixed bug where a score could be set to 0. the lowest a score can be now is 1

## [0.4.1] - 2024-06-30
- add score_penalty to the list details hash

## [0.4.0] - 2024-06-26
- Added score_penalty feature to allow percentage-based penalties on item scores.
- Updated all dependencies to their latest versions.

## [0.3.1] - 2024-05-026

- Fixed issue with lists with only a single item getting bonus points

## [0.3.0] - 2024-02-03

- added bonus_pool_percentage feature to exponential

## [0.2.0] - 2024-02-03

- refactored the exponential algorithm to only add bonus points out of a pool of 50% of a list's weight

## [0.1.3] - 2024-02-03

- sort the score_details by the highest score from each list first

## [0.1.2] - 2024-02-03

- Added list weight to rank result
- 
## [0.1.1] - 2024-02-03

- Fixed Exponential strategy to just return the list weight if the item has a nil position

## [0.1.0] - 2024-02-01

- Initial release
