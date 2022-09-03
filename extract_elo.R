# extract_elo.R
#
# Brian Goodwin, 2018-09-02
#
# Gets elo csv from https://projects.fivethirtyeight.com/nfl-api/2017/nfl_games_2017.csv
#
# 2018 season
# https://projects.fivethirtyeight.com/nfl-api/2018/nfl_games_2018.csv
#
# 538 Github project with details:
# https://github.com/fivethirtyeight/nfl-elo-game

library(stringr)
library(tidyverse)
library(arrow)
library(ggplot2)

tmp <- read_csv("./data/nfl_elo_latest copy.csv")

# 1) Visit the site above with the right year,
# 2) then select all
# 3) copy to text file
# 4) save as CSV.
# 5) Run script below

SAVE__ <- TRUE

CURRENT_YEAR <- 2022
YEARS <- seq(2017, CURRENT_YEAR - 1)

for (year in YEARS) {

  # team1 is the home team
  URL <- paste0("https://projects.fivethirtyeight.com/nfl-api/", year, "/nfl_games_", year, ".csv")

  teamElo <- read_csv(URL)
  write_csv(teamElo, file = paste0("./data/nflelo_", year, ".csv"))
  write_parquet(teamElo, paste0("./data/nflelo_", year, ".parquet"))
}

df <- bind_rows(lapply(YEARS, function(x) read_parquet(paste0("./data/nflelo_", x, ".parquet"))))
write_parquet(df, paste0("./data/elo-data-thru", CURRENT_YEAR - 1, ".parquet"))

# Example Elo for da bears >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
df <- read_parquet(paste0("./data/elo-data-thru", CURRENT_YEAR - 1, ".parquet"))
tmp <- bind_rows(
  df[c("date", "team1", "elo1")] %>% rename(team = team1, elo = elo1),
  df[c("date", "team2", "elo2")] %>% rename(team = team2, elo = elo2)
)

ggplot(tmp %>% filter(team == "CHI") %>% arrange(date) %>% mutate(gameNum=seq(n()))) +
  geom_line(aes(gameNum, elo)) +
  geom_point(aes(gameNum, elo)) +
  theme_bw()
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# # data structure changed 2021;
# teamElo <- rbind(
#   teamElo[c("date", "team1", "elo1_post")] %>% rename(team = team1, elo = elo1_post),
#   teamElo[c("date", "team2", "elo2_post")] %>% rename(team = team2, elo = elo2_post)
# )

teamElo <- bind_rows(
  df[c("date", "team1", "elo1")] %>% rename(team = team1, elo = elo1),
  df[c("date", "team2", "elo2")] %>% rename(team = team2, elo = elo2)
)

teamElo <- teamElo %>% mutate(date = as.Date(date, format = "%m/%d/%y"))

teamElo <- teamElo %>%
  group_by(team) %>%
  slice(which.max(date))

# # # From old analysis:
# # Probability for a given team winning a game (apparently):
# # Pr(A) = 1 / (10^(-ELODIFF/400) + 1)
#
# teamElo$pa <- 1/(exp(-(teamElo$elo1-teamElo$elo2)/400)+1)
# teamElo$pa10 <- 1/(10^(-(teamElo$elo1-teamElo$elo2)/400)+1)
#
# hist(teamElo$pa, probability = TRUE, 20)

if (SAVE__) {
  save(teamElo, file = paste0("./data/newElos_", CURRENT_YEAR, ".RData"))
  # write.csv(teamElo, file = "../data/eloHistory_2021.csv",quote = FALSE,row.names = FALSE,eol = "\n")
}
