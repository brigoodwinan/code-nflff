# load_data.R
# 
# Brian D Goodwin, PhD, 2018-07-25
# 
# Loads in datasets.

library(jsonlite)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)

df <- fromJSON(txt = "../data/games_1512362753.8735218.json",flatten = TRUE) %>% as_data_frame()
save(df,file = "../data/games.RData")

profdf <- fromJSON(txt = "../data/profiles_1512362725.022629.json",flatten = TRUE) %>% as_data_frame()
save(profdf,file = "../data/profiles.RData")

elo <- read.csv(file = "../data/team_elo.csv",stringsAsFactors = F) %>% as_data_frame()
elo$yr <- sapply(X = elo$dt,FUN = function(X){
  st <- str_locate_all(string = X,pattern = "/")[[1]][2,1]+1
  en <- st+1
  tmp <- as.numeric(str_sub(string = X,start = st,end = en)[[1]])
  if (tmp > 20)
  {
    tmp <- tmp + 1900
  } else {
    tmp <- tmp + 2000
  }
  return(tmp)
})
elo$dy <- sapply(X = elo$dt,FUN = function(X){
  st <- str_locate_all(string = X,pattern = "/")[[1]][1,1]+1
  en <- str_locate_all(string = X,pattern = "/")[[1]][2,1]-1
  tmp <- as.numeric(str_sub(string = X,start = st,end = en)[[1]])
  return(tmp)
})
elo$mo <- sapply(X = elo$dt,FUN = function(X){
  st <- 1
  en <- str_locate_all(string = X,pattern = "/")[[1]][1,1]-1
  tmp <- as.numeric(str_sub(string = X,start = st,end = en)[[1]])
  return(tmp)
})
elo <- elo %>% mutate(date=as.Date(paste0(as.character(yr),"-",as.character(mo),"-",as.character(dy)))) %>% 
  select(-yr,-mo,-dy,-dt)

save(elo,file = "../data/teamElo.RData")

