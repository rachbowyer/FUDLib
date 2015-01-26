/*
  Demonstrates how to use fud_soundex
*/


create table people (
  surname	    varchar(50),     
  firstname	    varchar(50),
  soundexcode	    char(4)	    
);

create unique index people_primarykey on people(surname, firstname); 
create index people_soundex on people(soundexcode);


insert into people values('Rachel', 'Bowyer', fud_soundex('Bowyer'));
insert into people values('Rob', 'Byrne', fud_soundex('Byrne'));


select surname, firstname from people where soundexcode = fud_soundex('Bowyer');
select surname, firstname from people where soundexcode = fud_soundex('Bower');
select surname, firstname from people where soundexcode = fud_soundex('byrne');
select surname, firstname from people where soundexcode = fud_soundex('Burn');

