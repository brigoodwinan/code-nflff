# make_schedule.R


library(plyr)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)
library(RMariaDB)

LOAD__ <- FALSE

if (LOAD__)
{
    sched <- read.csv(file = "../data/schedule_2019.csv", stringsAsFactors = FALSE)
    save(sched, file = "../data/schedule_2019.RData")    
}

load("../data/schedule_2019.RData")

sch <- melt(data = sched,id.vars = c(1),variable.name = "GameNum",value.name = "OPP")

sch$home <- 1
sch$home[str_detect(string = sch$OPP,pattern = "@")] <- 0
sch$GameNum <- str_remove(string = sch$GameNum,pattern = "X") %>% as.integer()
sch$OPP <- str_remove(sch$OPP,"@")

# # DO NOT RUN because it reduces the schedule down too much
# sch <- sch %>% mutate(team1=ifelse(test = home==1,TEAM,OPP),team2=ifelse(test = home==0,TEAM,OPP))
# sch <- sch %>% distinct(team1,team2,GameNum)

# # Connect to my-db as defined in ~/.my.cnf
# conn <- dbConnect(RMariaDB::MariaDB(), group = "rs-dbi") # nflff database
# 
# # Write data to table
# dbWriteTable(conn, value = sch, name = "schedule_2018", append = TRUE )
# dbDisconnect(conn)

save(sch, file = "../data/schedule_fin_2019.RData")
