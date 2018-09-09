use nflff;
drop table schedule_2018;
create table schedule_2018 (
TEAM varchar(5),GameNum int,OPP varchar(5),home boolean
);

load data local infile '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/schedule_2018.csv'
into table schedule_2018 
fields terminated by ','
-- lines terminated by '\r\n'
lines terminated by '\n'
-- ENCLOSED BY '"'
IGNORE 1 LINES
;
