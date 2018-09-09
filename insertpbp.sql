load data local 
infile '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/pbp-2017_2.csv' 
into table pbp 
fields terminated by ','
lines terminated by '\r\n'
IGNORE 1 LINES
;
