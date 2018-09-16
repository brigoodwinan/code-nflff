SELECT *
FROM schedule_2018
WHERE GameNum = 1
INTO OUTFILE '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/games.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';