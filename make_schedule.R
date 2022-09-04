# make_schedule.R

library(tidyverse)
library(reshape2)

LOAD__ <- TRUE

CURRENT_YEAR <- 2022

if (LOAD__) {
  sched <- read_delim(file = paste0("./data/schedule_grid_", CURRENT_YEAR, ".txt"), delim = "\t")

  ofilename <- paste0("./data/schedule_", CURRENT_YEAR, ".RData")

  save(sched, file = ofilename)
  write_parquet(sched, paste0("./data/schedule_", CURRENT_YEAR, "parquet"))
} else {
  load(ofilename)
}

sch <- melt(data = sched, id.vars = c(1), variable.name = "GameNum", value.name = "OPP", factorsAsStrings = TRUE) |> as_tibble()

sch$home <- 1
sch$home[str_detect(string = sch$OPP, pattern = "@")] <- 0
sch <- sch |>
  group_by(TEAM) |>
  mutate(GameNum = seq(n())) |>
  ungroup()
sch$OPP <- str_remove(sch$OPP, "@")

# # DO NOT RUN because it reduces the schedule down too much
# sch <- sch |> mutate(team1=ifelse(test = home==1,TEAM,OPP),team2=ifelse(test = home==0,TEAM,OPP))
# sch <- sch |> distinct(team1,team2,GameNum)

# # Connect to my-db as defined in ~/.my.cnf
# conn <- dbConnect(RMariaDB::MariaDB(), group = "rs-dbi") # nflff database
#
# # Write data to table
# dbWriteTable(conn, value = sch, name = "schedule_2018", append = TRUE )
# dbDisconnect(conn)

save(sch, file = paste0("./data/schedule_fin_", CURRENT_YEAR, ".RData"))
write_parquet(sch, paste0("./data/schedule_fin_", CURRENT_YEAR, ".parquet"))
