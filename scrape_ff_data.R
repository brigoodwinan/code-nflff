# scrape_ff_data.R
# 
# Brian D Goodwin, PhD, 2018-09-23
# 
# Scrapes data from a website.

library(plyr)
library(dplyr)
library(tidyr)
library(stringr)
library(reshape2)
library(rvest)
library(RMariaDB)

pos <- c("QB","RB","WR","TE","K","DST")
wk <- 1:2

fin <- data.frame()
finK <- data.frame()
finDST <- data.frame()

for (i in wk)
{
  for (k in pos)
  {
    Sys.sleep(2.25+runif(1))
    pg <- read_html(paste0("https://www.footballdb.com/fantasy-football/index.html?pos=",k,"&yr=2018&wk=",i,"&rules=1"))
    
    df <- html_table(pg,fill=TRUE)[[1]]
    
    if (!(k=="K" | k=="DST"))
    {
      colnames(df) <- str_c(colnames(df),df[1,],sep="_")
      colnames(df)[1] <- "player"
      df <- df[-1,]
    }
    
    df$wk <- i
    df$pos <- k
    
    if (k=="K")
    {
      finK <- rbind(finK,df)
    } else if (k=="DST") {
      finDST <- rbind(finDST,df)
    } else {
      fin <- rbind(fin,df)  
    }
  }
}

# # Temporary save 
# save(fin,finK,finDST,file = "../data/ff_data_week1_week2.RData")

for (k in pos)
{
  Sys.sleep(2.25+runif(1))
  # Points against
  pg <- read_html(paste0("https://www.footballdb.com/fantasy-football/points-allowed.html?pos=",k))
  tmp <- html_table(pg,fill=TRUE)[[1]]
  
  cns <- str_c(str_sub(colnames(tmp),start=1,end=str_locate(colnames(tmp)," ")[,1]-1),tmp[1,],sep="_")
  cns[1] <- "team"
  tmp <- tmp[-1,]
  colnames(tmp) <- cns
  
  ## Find teams in team string
  conn <- dbConnect(RMariaDB::MariaDB(), group = "rs-dbi") # nflff database
  q <- paste0("
              SELECT * 
              FROM FootballdbdotcomTeamAbbrv;
              ")
  res <- dbSendQuery(conn, q)
  ta <- dbFetch(res) %>% as_data_frame()
  dbClearResult(res)
  dbDisconnect(conn)
  uabbv <- unique(ta$team)
  theteam <- lapply(uabbv,function(X){str_detect(tmp[,1],X)})
  
  ## Certain teams don't show up
  logind <- unlist(lapply(lapply(theteam,which),function(X){length(X)==0}))
  
  teamnameref <- rep(NA,length(logind))
  teamnameref[!logind] <- tmp[unlist(lapply(theteam,which)),1]
  
  pointsAgainst <- data_frame(ref = teamnameref,team = uabbv) %>% left_join(ta,by=c("team"="team")) %>% right_join(tmp,by=c("ref"="team")) %>% select(-ref,-team) %>% dplyr::rename(team=conv)
  
}
