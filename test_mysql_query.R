# test_mysql_query.R
# 
# queries nfl database as a test.

library(DBI)
# library(RMySQL) # Use RMariaDB
library(RMariaDB)

# Connect to my-db as defined in ~/.my.cnf
conn <- dbConnect(RMariaDB::MariaDB(), group = "rs-dbi") # nflff database

# nflff database
# +-------------------+
# | Tables_in_nflff   |
# +-------------------+
# | eloHistory        |
# | pbp               |
# | schedule_2018     |
# | teamAbbreviations |
# +-------------------+

# Build a query and get data
q <- paste0("
  SELECT * 
    FROM schedule_2018
  ")
res <- dbSendQuery(conn, q)
sched <- dbFetch(res) %>% as_data_frame()
dbClearResult(res)



# Disconnect
dbDisconnect(conn)



