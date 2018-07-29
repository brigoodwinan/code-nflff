# data_reduction.R
# 
# Brian D Goodwin, PhD, 2018-07-25
# 
# reduces loaded data.

library(dplyr)
library(reshape2)
library(tidyr)

load("../data/games.RData") # df
load("../data/profiles.RData") # profdf

df$date <- strptime(x = df$date,format = "%Y-%m-%d") %>% as.Date()

df <- df[df$date>as.Date("2016-04-01"),]
df$game_number <- as.numeric(df$game_number)
