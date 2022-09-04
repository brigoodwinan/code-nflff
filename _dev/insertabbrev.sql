use nflff;
drop table teamAbbreviations;
create table teamAbbreviations (team varchar(5), conv varchar(5));
load data local infile '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/teamAbbreviationConversions.csv' 
into table teamAbbreviations 
fields terminated by ','
lines terminated by '\r\n'
# ENCLOSED BY '"'
;
