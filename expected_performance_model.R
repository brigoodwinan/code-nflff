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

library(reshape2)
library(tidyverse)

CURRENT_YEAR <- 2022

# df <- read_csv('./data/nfl_elo_latest copy.csv')
df <- write_parquet(df, paste0("./data/elo-data-thru", CURRENT_YEAR - 1, ".parquet"))
load('./data/newElos_2021.RData') # teamElo
# load('./data/schedule2021.RData') # sch 
sch <- read_parquet(paste0("./data/schedule_fin_", CURRENT_YEAR, ".parquet"))

df <- df %>% mutate(date = as.Date(date,format = "%m/%d/%y")) %>% 
  transmute(elo1 = elo1_pre, elo2=elo2_pre,home=sample(c(1,0),n(),replace = TRUE),W=score1 > score2)
df$tmp <- df$elo2
logind <- df$home==0
df$elo2[logind] <- df$elo1[logind]
df$elo1[logind] <- df$tmp[logind]
df$W[logind] <- !df$W[logind]
df <- df %>% select(-tmp)
df <- df %>% mutate(home = as.logical(home))

mdl <- glm(data = df, formula = W ~ home + elo1 + elo2, family = "binomial")

teamElo <- teamElo %>% transmute(team,elo)

dat <- sch %>% left_join(teamElo, by = c("Team"="team")) %>% rename(elo1=elo)
dat <- dat %>% left_join(teamElo, by = c("OPP"="team")) %>% rename(elo2=elo)
dat[is.na(dat)] <- 1500
dat$home <- as.logical(dat$home)
dat <- dat %>% filter(OPP != "BYE")
dat$pwin <- predict(mdl,dat,type='response')

dat <- dat %>% group_by(Team) %>% summarise(outcome = sum(log(pwin)),.groups='drop') %>% arrange(desc(outcome))

write_csv(dat, './data/outcome2021.csv')

# 
# finElo <- teamElo %>% group_by(team1) %>% slice(which.max(date))
# 
# finElo <- finElo %>% select(team1,elo1)
# 
# 
# 
# print(summary(mdl))
# 
# sch <- sch %>% left_join(finElo,by=c("TEAM"="team1")) %>% dplyr::rename(teamElo=elo1)
# sch <- sch %>% left_join(finElo,by=c("OPP"="team1")) %>% dplyr::rename(oppElo=elo1)
# 
# sch <- sch %>% mutate(game_location = ifelse(home,"H","A")) %>% mutate(prob = predict(newdata = ., object = mdl, type = "response"))
# 
# # FINAL OUTPUT
# sch %>% group_by(TEAM) %>% dplyr::summarise(outcome = sum(log(prob), na.rm = TRUE)) %>% arrange(desc(outcome)) %>% write.csv(file = paste0("../",Sys.Date(),"_outcome.csv"), row.names = FALSE)
