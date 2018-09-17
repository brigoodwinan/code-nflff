use nflff;
drop table schedule_2018;
create table schedule_2018 (
    GameNum int
    ,team1 varchar(5)
    ,team2 varchar(5)
    ,primary key (GameNum,team1)
);

-- load data local infile '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/schedule_2018.csv'
-- into table schedule_2018 
-- fields terminated by ','
-- -- lines terminated by '\r\n'
-- lines terminated by '\n'
-- -- ENCLOSED BY '"'
-- IGNORE 1 LINES
-- ;
