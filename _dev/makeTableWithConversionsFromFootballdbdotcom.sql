use nflff;
drop table FootballdbdotcomTeamAbbrv;

create table FootballdbdotcomTeamAbbrv (
    team varchar(50)
    ,conv varchar(5)
    ,INDEX (team(5),conv)
    );


load data local infile '/Users/briangoodwin/Documents/nfl_fantasyFootball_statHuzzah/data/teamsForfootballdatabasedotcom.csv' 
into table FootballdbdotcomTeamAbbrv 
fields terminated by ','
lines terminated by '\r\n'
ignore 1 lines
-- ENCLOSED BY '"'
;
