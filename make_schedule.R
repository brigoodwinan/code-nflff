# make_schedule.R
# 
# converts schedule into a CSV that can be loaded into mysql.

library(plyr)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)
library(RMariaDB)

load("../data/schedule_2018.RData")

sch <- melt(data = sched,id.vars = c(1),variable.name = "GameNum",value.name = "OPP")

sch$home <- 1
sch$home[str_detect(string = sch$OPP,pattern = "@")] <- 0
sch$GameNum <- str_remove(string = sch$GameNum,pattern = "X") %>% as.integer()
sch$OPP <- str_remove(sch$OPP,"@")

sch <- sch %>% mutate(team1=ifelse(test = home==1,TEAM,OPP),team2=ifelse(test = home==0,TEAM,OPP))
sch <- sch %>% distinct(team1,team2,GameNum)

# Connect to my-db as defined in ~/.my.cnf
conn <- dbConnect(RMariaDB::MariaDB(), group = "rs-dbi") # nflff database

# Write data to table
dbWriteTable(conn, value = sch, name = "schedule_2018", append = TRUE )
dbDisconnect(conn)

# Write to CSV file
write.csv(sch,file = "../data/schedule_2018.csv",row.names = FALSE,eol = "\n",quote = FALSE)
