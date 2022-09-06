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
#
# as of 2022, OAK needs to be changed to LV (see line below)

library(reshape2)
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(arrow)

CURRENT_YEAR <- 2022

df <- read_parquet(paste0("./data/elo-data-thru", CURRENT_YEAR - 1, ".parquet"))
load("./data/newElos_2021.RData") # teamElo
sch <- read_parquet(paste0("./data/schedule_fin_", CURRENT_YEAR, ".parquet"))

# as of 2021 anything with OAK needs to be changed to LV (Raiders moved to Las Vegas)
df$team1[df$team1 == "OAK"] <- "LV"
df$team2[df$team2 == "OAK"] <- "LV"
teamElo$team[teamElo$team == "OAK"] <- "LV"
teamElo <- teamElo |> transmute(team, elo)

g <- function(indf, schedule, returnSchedule = FALSE) {
  dat <- indf |>
    mutate(date = as.Date(date, format = "%m/%d/%y")) |>
    transmute(elo1, elo2, home = sample(c(1, 0), n(), replace = TRUE), W = score1 > score2, homeTeamElo = elo1)

  dat$homeTeam <- as.matrix(indf[c("team1", "team2")])[cbind(seq(nrow(dat)), abs(dat$home - 2))] # clever indexing for model

  dat$tmp <- dat$elo2
  logind <- dat$home == 0
  dat$elo2[logind] <- dat$elo1[logind]
  dat$elo1[logind] <- dat$tmp[logind]
  dat$W[logind] <- !dat$W[logind]
  dat <- dat |> select(-tmp)
  dat <- dat |> mutate(home = as.logical(home))
  elodist <- as.numeric(unlist(c(dat[c("elo1", "elo2")])))
  center <- mean(elodist)
  scale <- sd(elodist)
  dat[c("elo1", "elo2", "homeTeamElo")] <- (dat[c("elo1", "elo2", "homeTeamElo")] - center) / scale

  mdl <- glm(data = dat, formula = W ~ home + elo1 + elo2 + homeTeamElo:homeTeam, family = "binomial")
  # summary(mdl) # AIC: 1752.7

  # mdl <- glm(data = dat, formula = W ~ home + elo1 + elo2, family = "binomial")
  # summary(mdl) # AIC: 1724.8

  # Lower AIC score is better, but these differences are negligible so using the
  # homeTeam variable in the model should be the advantage

  schedule$homeTeam <- ifelse(as.logical(schedule$home), schedule$TEAM, schedule$OPP)

  dfpro <- schedule |>
    left_join(teamElo, by = c("TEAM" = "team")) |>
    rename(elo1 = elo)
  dfpro <- dfpro |>
    left_join(teamElo, by = c("OPP" = "team")) |>
    rename(elo2 = elo)
  dfpro <- dfpro |>
    left_join(teamElo, by = c("homeTeam" = "team")) |>
    rename(homeTeamElo = elo)
  dfpro[is.na(dfpro)] <- 1500
  dfpro$home <- as.logical(dfpro$home)
  dfpro <- dfpro |> filter(OPP != "BYE")
  dfpro[c("elo1", "elo2", "homeTeamElo")] <- (dfpro[c("elo1", "elo2", "homeTeamElo")] - center) / scale

  # Model prediction
  pwin <- predict(mdl, dfpro, type = "response")
  if (returnSchedule) {
    return(dfpro[c("TEAM", "GameNum", "OPP", "home")])
  } else {
    return(pwin)
  }
}

probs <- 0
N <- 200
for (k in seq(N)) {
  probs <- g(df, sch) + probs
}
probs <- probs / N

# one more time to get the schedule
sch <- g(df, sch, returnSchedule = TRUE)
sch$pwin <- probs
write_parquet(sch, paste0("./data/results_WinProbabilities_", CURRENT_YEAR, ".parquet"))

sch <- sch |>
  group_by(TEAM) |>
  summarise(outcome = sum(log(pwin)), .groups = "drop") |>
  arrange(desc(outcome))

write_parquet(sch, paste0("./data/results_PredictedOutcomes_", CURRENT_YEAR, "parquet"))

# Plotting >>>>>>>>>>>>>
sch <- read_parquet(paste0("./data/results_PredictedOutcomes_", CURRENT_YEAR, "parquet"))
sch <- sch |> rename(pred=outcome)
sch <- sch |> left_join(teamElo, by = c("TEAM" = "team"))
sch[c("pred", "elo")] <- scale(sch[c("pred", "elo")])
sch <- sch |> mutate(diff = pred - elo)

tmp <- pivot_longer(sch, cols = c("pred", "elo"))
tmp <- tmp |> left_join(tmp |> filter(name == "pred") |> transmute(TEAM, pred = value))
tmp <- tmp |> left_join(sch[c("TEAM", "diff")])
tmp$linecolor <- tmp$diff > 0

plt <- ggplot(tmp) +
  geom_line(aes(x = value, y = reorder(TEAM, pred), group = TEAM, color = linecolor)) +
  scale_color_manual(values = c("red", "black")) +
  geom_point(aes(x = value, y = reorder(TEAM, pred), pch = name), color = "black", size = 3) +
  scale_shape_manual(values = c(1, 19)) +
  scale_y_discrete(position = "right") +
  theme_bw() +
  xlab("Expected Team Performance (Arbitrary Scale)") +
  theme(
    axis.title.y = element_blank(),
    legend.position = c(.1, .5),
    legend.box.background = element_rect(color = "black"),
    legend.title = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_blank()
  ) +
  guides(color = "none")

ggsave("./results/outcome.png",plot = plt, device = "png",width = 7.5,height = 5, dpi = 300,units = "in")
