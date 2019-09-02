# extract_elo.R
# 
# Brian Goodwin, 2018-09-02
# 
# Gets elo csv from https://projects.fivethirtyeight.com/nfl-api/2017/nfl_games_2017.csv
# 
# 2018 season
# https://projects.fivethirtyeight.com/nfl-api/2018/nfl_games_2018.csv

library(plyr)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)

# 1) Visit the site above with the right year, 
# 2) then select all
# 3) copy to text file
# 4) save as CSV.
# 5) Run script below

SAVE__ <- TRUE

teamElo <- read.csv(file = "../data/team_elo_2018.csv",stringsAsFactors = FALSE) %>% as_tibble()

# Probability for a given team winning a game (apparently):
# Pr(A) = 1 / (10^(-ELODIFF/400) + 1)

teamElo$pa <- 1/(exp(-(teamElo$elo1-teamElo$elo2)/400)+1)
teamElo$pa10 <- 1/(10^(-(teamElo$elo1-teamElo$elo2)/400)+1)

hist(teamElo$pa, probability = TRUE, 20)

if (SAVE__)
{
    save(teamElo,file = "../data/newElos_2018.RData")
    write.csv(teamElo, file = "../data/eloHistory_2018.csv",quote = FALSE,row.names = FALSE,eol = "\n")
}
    


