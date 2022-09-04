use nflff;
drop table eloHistory;
create table eloHistory (
GameDate date
,season int
,neutral boolean
,playoff boolean
,team1 varchar(5)
,team2 varchar(5)
,elo1 float
,elo2 float
,elo_prob1 decimal(11,10)
,score1 int
,score2 int
,result1 boolean
);

load data local infile '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/nfl-elo-game-master_538/data/nfl_games.csv'
into table eloHistory 
fields terminated by ','
-- lines terminated by '\r\n'
lines terminated by '\n'
-- ENCLOSED BY '"'
IGNORE 1 LINES
;
