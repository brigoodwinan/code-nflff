# expected_performance_model.R
# 
# Brian D Goodwin, PhD, 2018-07-25
# 
# Quantifies expected performance (or difficulty) of a given season for each
# team.
# 
# Inputs are team elo, opponent elo, away/home, outputs are win/loss

library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)

load("../data/games.RData") # df
load("../data/teamElo.RData") # elo
load("../data/teamAbbreviationConversions.RData") # abbrConv

team <- df %>% distinct(date,team,game_location,opponent,game_won)

redelo <- elo %>% distinct(tname,elo,date) %>% left_join(abbrConv,by=c("tname"="team")) %>% select(-tname) %>% dplyr::rename(team=conv)

team <- team %>% filter(date>as.Date("2015-05-01")) %>% left_join(abbrConv,by=c("team"="team")) %>% select(-team) %>% dplyr::rename(team=conv) %>%
  left_join(abbrConv,by=c("opponent"="team")) %>% select(-opponent) %>% dplyr::rename(opponent=conv) %>% 
  left_join(redelo,by=c("date"="date","team"="team")) %>% dplyr::rename(teamElo=elo) %>% 
  left_join(redelo,by=c("date"="date","opponent"="team")) %>% dplyr::rename(oppElo=elo)

load("../data/newElos_2018.RData")
teamElo$date <- as.Date(teamElo$date)

finElo <- teamElo %>% group_by(team1) %>% slice(which.max(date))

finElo <- finElo %>% select(team1,elo1)

teamElo <- teamElo %>% select

mdl <- glm(data = team,formula = game_won ~ game_location + teamElo + oppElo,family = "binomial")

load("../data/schedule_fin_2019.RData")

sch <- sch %>% left_join(finElo,by=c("team1"="team1")) %>% dplyr::rename(TEAMELO=elo1)
sch <- sch %>% left_join(finElo,by=c("team2"="team1")) %>% dplyr::rename(OPPELO=elo1)

