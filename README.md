## Fantasy Football Modeling for 2018 Season ##

Need to know the schedule to understand bye weeks and match difficulties.

Handle situations where BYE weeks don't overlap with players.

Need to be able to create a list of all players with priority regardless of position because that is how the draft works:
e.g.:
1. Aa - WR
2. Bb - RB
3. Cc - QB
4. Dd - QB
5. Ee - WR
6. etc.

Use team Elo and a penalty for an away game. - model fit on previous seasons, which use ELOs, and away v home. - logistic regression: [Team elo], [opp elo], [a/h], output: [W/L]

# STEP 1: extract_elo.R

Get the CSV from the following site... 538 does a good job... (Currently we don't have a backup solution.)
2018 season
https://projects.fivethirtyeight.com/nfl-api/2018/nfl_games_2018.csv

1) Visit the site above with the right year
2) then select all
3) copy to text file
4) save as CSV.
5) Run extract_elo.R

# STEP 2: make_schedule.R

http://theredzone.org/Schedule/NFL-Schedule-Grid

Copy Schedule to text file like ../data/schedule_2019.txt. Open excel, import data > schedule_2019.txt > save as csv > (make_schedule.R) load into R using read.csv > then save as an RData File > run the rest of make_schedule.R

# (optional) STEP 2a:

Update historical data - you will have to search through scripts to uncover where the historical games came from in order to generate the file named:

> load("../data/games.RData") # df

# STEP 3: expected_performance_model.R

Run expected performance and look at final output.