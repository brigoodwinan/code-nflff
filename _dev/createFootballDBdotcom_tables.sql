use nflff
drop table pointsAgainst_QB;
create table pointsAgainst_QB (
team varchar(10)
,Season_Gms float
,Season_PassYds float
,Season_PassInt float
,Season_PassTD float
,Season_RushAtt float
,Season_RushYds float
,Season_RushTD float
,Season_Pts float
,Game_PassYds float
,Game_PassInt float
,Game_PassTD float
,Game_RushAtt float
,Game_RushYds float
,Game_RushTD float
,Game_Pts float
,datestamp date
,primary key (team,datestamp)
);


drop table pointsAgainst_RB;
create table pointsAgainst_RB (
team varchar(10)
,Season_Gms float
,Season_RushAtt float
,Season_RushYds float
,Season_RushTD float
,Season_RecNum float
,Season_RecYds float
,Season_RecTD float
,Season_RecTar float
,Season_Pts float
,Game_RushAtt float
,Game_RushYds float
,Game_RushTD float
,Game_RecNum float
,Game_RecYds float
,Game_RecTD float
,Game_RecTar float
,Game_Pts float
,datestamp date
,primary key (team,datestamp)
);

drop table pointsAgainst_WR;
create table pointsAgainst_WR (
team varchar(10)
,Season_Gms float
,Season_Rec float
,Season_Yds float
,Season_TD float
,Season_Tar float
,Season_Pts float
,Game_Rec float
,Game_Yds float
,Game_TD float
,Game_Tar float
,Game_Pts float
,datestamp date
,primary key (team,datestamp)
);

drop table pointsAgainst_TE;
create table pointsAgainst_TE (
team varchar(10)
,Season_Gms float
,Season_Rec float
,Season_Yds float
,Season_TD float
,Season_Tar float
,Season_Pts float
,Game_Rec float
,Game_Yds float
,Game_TD float
,Game_Tar float
,Game_Pts float
,datestamp date
,primary key (team,datestamp)
);

drop table pointsAgainst_K;
create table pointsAgainst_K (
team varchar(10)
,Season_Gms float
,Season_PAT varchar(20)
,Season_FG varchar(20)
,Season_FG50 float
,Season_Pts float
,Game_PAT varchar(20)
,Game_FG varchar(20)
,Game_FG50 float
,Game_Pts float
,datestamp date
,primary key (team,datestamp)
);

drop table pointsAgainst_DST;
create table pointsAgainst_DST (
team varchar(10)
,Season_Gms float
,Season_Sack float
,Season_Int float
,Season_FRec float
,Season_Blk float
,Season_Saf float
,Season_TD float
,Season_PA float
,Season_Pts float
,Game_Sack float
,Game_Int float
,Game_FRec float
,Game_Blk float
,Game_Saf float
,Game_TD float
,Game_PA float
,Game_Pts float
,datestamp date
,primary key (team,datestamp)
);