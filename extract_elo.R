# extract_elo.R
# 
# Brian Goodwin, 2018-09-02
# 
# Gets elo csv from https://projects.fivethirtyeight.com/nfl-api/2017/nfl_games_2017.csv

library(plyr)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)

# teamElo <- read.csv(file = "../data/nfl-elo-game-master_538/data/nfl_games_2017.csv",stringsAsFactors = FALSE) %>% as_data_frame()
# 
# save(teamElo,file = "../data/newElos.RData")

# Probability for a given team winning a game (apparently):
# Pr(A) = 1 / (10^(-ELODIFF/400) + 1)

# teamElo$pa <- 1/(exp(-(teamElo$elo1-teamElo$elo2)/400)+1)
# teamElo$pa10 <- 1/(10^(-(teamElo$elo1-teamElo$elo2)/400)+1)

load("../data/newElos.RData")

write.csv(teamElo,file="../data/eloHistory_2017.csv",quote = FALSE,row.names = FALSE,eol = "\n")
