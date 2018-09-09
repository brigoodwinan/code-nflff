# make_schedule.R
# 
# converts schedule into a CSV that can be loaded into mysql.

library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)

load("../data/schedule_2018.RData")

sch <- melt(data = sched,id.vars = c(1),variable.name = "GameNum",value.name = "OPP")

sch$home <- 1
sch$home[str_detect(string = sch$OPP,pattern = "@")] <- 0
sch$GameNum <- str_remove(string = sch$GameNum,pattern = "X") %>% as.integer()
sch$OPP <- str_remove(sch$OPP,"@")

write.csv(sch,file = "../data/schedule_2018.csv",row.names = FALSE,eol = "\n",quote = FALSE)
