# expected_performance_model.R
# 
# Brian D Goodwin, PhD, 2018-07-25
# 
# Quantifies expected performance (or difficulty) of a given season for each
# team.
# 
# Inputs are team elo, opponent elo, away/home, outputs are win/loss
# 
# This Script uses an older dataset of historical games... if interested in
# updating this script, you'd have to find where the historical games were
# acquired. The MDL near the end of this script uses a few years of a games to
# build a model that predicts w/l based on ELOs and away/home.

library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)

load("../data/games.RData") # df
load("../data/teamElo.RData") # elo
load("../data/teamAbbreviationConversions.RData") # abbrConv
load("../data/newElos_2018.RData") # teamElo
load("../data/schedule_fin_2019.RData") # sch

sch <- as_tibble(sch)

team <- df %>% distinct(date,team,game_location,opponent,game_won)

redelo <- elo %>% distinct(tname,elo,date) %>% left_join(abbrConv,by=c("tname"="team")) %>% select(-tname) %>% dplyr::rename(team=conv)

team <- team %>% filter(date>as.Date("2015-05-01") & game_location!="N") %>% left_join(abbrConv,by=c("team"="team")) %>% select(-team) %>% dplyr::rename(team=conv) %>%
    left_join(abbrConv,by=c("opponent"="team")) %>% select(-opponent) %>% dplyr::rename(opponent=conv) %>% 
    left_join(redelo,by=c("date"="date","team"="team")) %>% dplyr::rename(teamElo=elo) %>% 
    left_join(redelo,by=c("date"="date","opponent"="team")) %>% dplyr::rename(oppElo=elo)

teamElo$date <- as.Date(teamElo$date)

finElo <- teamElo %>% group_by(team1) %>% slice(which.max(date))

finElo <- finElo %>% select(team1,elo1)

mdl <- glm(data = team,formula = game_won ~ game_location + teamElo + oppElo,family = "binomial")

print(summary(mdl))

sch <- sch %>% left_join(finElo,by=c("TEAM"="team1")) %>% dplyr::rename(teamElo=elo1)
sch <- sch %>% left_join(finElo,by=c("OPP"="team1")) %>% dplyr::rename(oppElo=elo1)

sch <- sch %>% mutate(game_location = ifelse(home,"H","A")) %>% mutate(prob = predict(newdata = ., object = mdl, type = "response"))

# FINAL OUTPUT
sch %>% group_by(TEAM) %>% dplyr::summarise(outcome = sum(log(prob), na.rm = TRUE)) %>% arrange(desc(outcome)) %>% write.csv(file = paste0("../",Sys.Date(),"_outcome.csv"), row.names = FALSE)
