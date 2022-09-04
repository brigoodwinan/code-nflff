# Expected Outcomes for 2022 Season

![outcome](https://github.com/brigoodwinan/code-nflff/blob/master/results/outcome.png)

# Fantasy Football Modeling for 2018 Season

I rely a lot on data from 538: https://github.com/fivethirtyeight/nfl-elo-game

## Miscellaneous thoughts

Need to know the schedule to understand bye weeks and match difficulties. Handle situations where BYE weeks don't overlap with players. Future iterations should include player stats regardless of position because that is how the draft works, e.g.:

1. Aa - WR
2. Bb - RB
3. Cc - QB
4. Dd - QB
5. Ee - WR
6. etc.

Use team Elo and control for away game. - model fit on previous seasons, which use ELOs, and away v home. - logistic regression: [Team elo], [opp elo], [a/h], interaction(a/h,Team elo), output: [W/L]

# Running Statistical model

## 1 extract_elo.R

Uses the REST api from 538.

e.g., 2018 season

```r
df <- read_csv("https://projects.fivethirtyeight.com/nfl-api/2018/nfl_games_2018.csv")
```

## 2 make_schedule.R

The following was used to build the necessary data object for the schedule

https://theredzone.org/Schedule/NFL-Schedule-Grid

Copy Schedule to text file like ../data/schedule_grid_2022.txt. This script reads a tab delimited file.

## 3 expected_performance_model.R

Uses historical data and ELOs to build a model based on away/home opponents, ELOs, and NFL schedule difficulty. Produces a plot that illustrates model recommendations.
