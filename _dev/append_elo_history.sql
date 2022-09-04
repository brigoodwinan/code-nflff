use nflff;

load data local infile '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/eloHistory_2017.csv'
into table eloHistory 
fields terminated by ','
-- lines terminated by '\r\n'
lines terminated by '\n'
-- ENCLOSED BY '"'
IGNORE 1 LINES
;
