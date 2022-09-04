use nfl
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
,result1 decimal(2,1)
);