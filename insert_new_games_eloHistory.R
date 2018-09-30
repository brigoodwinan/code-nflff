# make_schedule.R
# 
# converts schedule into a CSV that can be loaded into mysql.

library(plyr)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)
library(RMariaDB)

df <- as_data_frame(read.csv(file = "../data/scores_game1.csv",stringsAsFactors = FALSE))
df <- rbind(df,as_data_frame(read.csv(file = "../data/scores_game2.csv",stringsAsFactors = FALSE)))

# Connect to my-db as defined in ~/.my.cnf
conn <- dbConnect(RMariaDB::MariaDB(), group = "rs-dbi") # nflff database

# nflff database
# mysql> describe eloHistory;
# +-----------+----------------+------+-----+---------+-------+
# | Field     | Type           | Null | Key | Default | Extra |
# +-----------+----------------+------+-----+---------+-------+
# | GameDate  | date           | YES  |     | NULL    |       |
# | season    | int(11)        | YES  |     | NULL    |       |
# | neutral   | tinyint(1)     | YES  |     | NULL    |       |
# | playoff   | tinyint(1)     | YES  |     | NULL    |       |
# | team1     | varchar(5)     | YES  |     | NULL    |       |
# | team2     | varchar(5)     | YES  |     | NULL    |       |
# | elo1      | float          | YES  |     | NULL    |       |
# | elo2      | float          | YES  |     | NULL    |       |
# | elo_prob1 | decimal(11,10) | YES  |     | NULL    |       |
# | score1    | int(11)        | YES  |     | NULL    |       |
# | score2    | int(11)        | YES  |     | NULL    |       |
# | result1   | decimal(2,1)   | YES  |     | NULL    |       |
# +-----------+----------------+------+-----+---------+-------+
# 12 rows in set (0.01 sec)

# Build a query and get data
q <- paste0("
            SELECT * 
              FROM eloHistory
                where season in (2016,2017);
            ")
res <- dbSendQuery(conn, q)
hs <- dbFetch(res) %>% as_data_frame()
dbClearResult(res)

# Disconnect
dbDisconnect(conn)

hs <- rbind(hs,df)

hs$result1 <- (hs$score1 > hs$score2) + 0.5*(hs$score1 == hs$score2)

# update ELOs

mdl <- glm(data = hs,formula = result1 ~ scale(elo1-elo2),family = quasibinomial(link = "logit"))
# # Win probabilities
# plot(mdl$model$`scale(elo1 - elo2)`,mdl$model$result1)
# pltdf <- data_frame(x = mdl$model$`scale(elo1 - elo2)` %>% as.numeric(),y = mdl$fitted.values)
# pltdf <- pltdf[with(pltdf,order(x)),]
# with(pltdf,lines(x,y))


