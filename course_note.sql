/*
DDL(data definition language)
create table 
drop table
dml(data manipulation language)
select
insert 
delete 
update

the basic select statement 
select A1,A2,...,An----what to return 
from   R1,R2,...,Rm----relations
Where condition--------combine filter 

-------------------------------------------
BASIC select
college(cName,state,enrollment)
Student(sID,sName,GPA,sizeHS)
Apply(sID,cName,major,decision)

college:
Stanford CA 15000
Berkeley  CA 36000
MIT       MA 10000
Cornell   NY 21000

Student:
123 Amy    3.9 1000
234 Bob    3.6 1500
345 Craig  3.5 500
456 Doris  3.9 1000
567 Edward 2.9 2000
678 Fay    3.8 200
789 Gary   3.4 800
987 Helen  3.7 800
876 Irene  3.9 400
765 Jay    2.9 1500
654 Amy    3.9 1000
543 Craig  3.4 2000

Apply:
123  Stanford  CS       Y
123  Stanford  EE       N
123  Berkeley  CS       Y
123  Cornell   EE       Y
234  Berkeley  biology  N
345  MIT       bioengineering Y
345  Cornell   bioengineering N
345  Cornell   CS             Y
345  Cornell   EE             N
678  Stanford  history        Y
987  Stanford  CS             Y
987  Berkeley  CS             Y
876  Stanford  CS             N 
876  MIT       biology        Y
876  MIT       marine biology N
765  Stanford  histroy        Y
765  Cornell   histroy        N
765  Cornell   psychology     Y
543  MIT       CS             N

----------------------------------------
*/

DROP TABLE IF EXISTS College;
CREATE TABLE College (
cName varchar(15) PRIMARY KEY,
state varchar(10),
enrollment int(11)
);

INSERT INTO College values('Stanford', 'CA', 15000);
INSERT INTO College values('Berkeley',  'CA', 36000);
INSERT INTO College values('MIT',       'MA', 10000);
INSERT INTO College values('Cornell',   'NY', 21000);

select *
from College;

DROP TABLE IF EXISTS Student;
CREATE TABLE Student(
sID int(5) PRIMARY KEY,
sName varchar(20),
GPA decimal(2,1),
sizeHS int(6)
);
INSERT INTO Student values(123, 'Amy',  3.9, 1000);
INSERT INTO Student values(234, 'Bob' ,   3.6, 1500);
INSERT INTO Student values(345, 'Craig',  3.5, 500);
INSERT INTO Student values(456, 'Doris' , 3.9, 1000);
INSERT INTO Student values(567 ,'Edward', 2.9, 2000);
INSERT INTO Student values(678, 'Fay' ,   3.8, 200);
INSERT INTO Student values(789, 'Gary',   3.4, 800);
INSERT INTO Student values(987, 'Helen',  3.7, 800);
INSERT INTO Student values(876, 'Irene',  3.9, 400);
INSERT INTO Student values(765, 'Jay',    2.9, 1500);
INSERT INTO Student values(654, 'Amy',    3.9, 1000);
INSERT INTO Student values(543, 'Craig',  3.4, 2000);

select *
from Student;

DROP TABLE IF EXISTS Apply;

CREATE TABLE Apply(
sID int(5),
cName varchar(15),
major varchar(15),
decision varchar(2),
PRIMARY KEY(sID,cName,major)
);

INSERT INTO Apply values(123,  'Stanford',  'CS',       'Y');
INSERT INTO Apply values(123,  'Stanford',  'EE',       'N');
INSERT INTO Apply values(123,  'Berkeley',  'CS',       'Y');
INSERT INTO Apply values(123,  'Cornell',   'EE',       'Y');
INSERT INTO Apply values(234,  'Berkeley',  'biology',  'N');
INSERT INTO Apply values(345,  'MIT',       'bioengineering', 'Y');
INSERT INTO Apply values(345,  'Cornell',   'bioengineering', 'N');
INSERT INTO Apply values(345,  'Cornell',   'CS',             'Y');
INSERT INTO Apply values(345,  'Cornell',   'EE' ,            'N');
INSERT INTO Apply values(678,  'Stanford',  'history',        'Y');
INSERT INTO Apply values(987,  'Stanford',  'CS',             'Y');
INSERT INTO Apply values(987,  'Berkeley',  'CS',             'Y');
INSERT INTO Apply values(876,  'Stanford',  'CS',             'N');
INSERT INTO Apply values(876,  'MIT',       'biology',       'Y');
INSERT INTO Apply values(876,  'MIT',       'marine biology', 'N');
INSERT INTO Apply values(765,  'Stanford',  'histroy',        'Y');
INSERT INTO Apply values(765,  'Cornell',   'histroy',        'N');
INSERT INTO Apply values(765,  'Cornell',   'psychology',     'Y');
INSERT INTO Apply values(543,  'MIT',       'CS',             'N');

select *
from Apply;

--#################################
--#################################
select sID,sName,GPA
from Student
where GPA>3.6;

select sName,major
from Student,Apply
where Student.sID=Apply.sID;

select sname,GPA,decision
from Student,Apply
where Student.sID=Apply.sID
and sizeHS<1000 and major='CS' and cname='stanford';

select distinct College.cName
from College,Apply
where College.cName=Apply.cName
and enrollment>20000 and major='CS';

select Student.sID,sName,GPA,Apply.cName,enrollment
from Student,College,Apply
where Apply.sID=Student.sID and Apply.cName=College.cName
order by GPA desc;

select sID,major
from Apply
where major like '%bio%';


select sID,sName,GPA,sizeHS,GPA*(sizeHS/1000.0) as scaledGPA
from Student;


--#################################
--#########################

select  S1.sID,S1.sName,S1.GPA,S2.sID,S2.sName,S2.GPA
from Student S1,Student S2
where S1.GPA=S2.GPA and S1.sID<S2.sID;

select cName from College
union
select sName from Student;

select sID from Apply where major ='CS'
intersect 
select sID from Apply where major ='EE';


select distinct A1.sID
from Apply A1,Apply A2
where A1.sID=A2.sID and A1.major='CS'and A2.major='EE';

select sID from Apply where major='CS'
except
select sID from Apply where major='EE';

select A1.sID
from Apply A1,Apply A2
where A1.sID=A2.sID and A1.major='CS' and A2.major<>'EE';

select sID,sName,sizeHS
from Student S1
where exists(select * from Student S2 where S2.sizeHS<S1.sizeHS);
--##################################
--####################################
select sID,sName
from Student
where sID in (select sID from Apply where major='CS');

select sID,sName
from Student
where sID in (select sID from Apply where major='CS')
and sID not in (select sID from Apply where major='EE');

select cName,state
from College C1
where exists(select * from College C2
where C2.state=C1.state and C1.cName<>C2.cName);

select cName
from College C1
where not exists(select * from College C2
                 where C2.enrollment>C1.enrollment );

select sName,GPA
from Student C1
where not exists(select * from Student C2
                 where C2.GPA>C1.GPA);
                 

select S1.sName,S1.GPA
from Student S1,Student S2
where S1.GPA>S2.GPA;

select sName,GPA
from Student
where GPA>=all(select GPA from Student);

select sName
from Student S1
where GPA>all(select GPA from Student S2
             where S2.sID<>S1.sID);
             
select cName
from College S1
where enrollment>all(select enrollment from College S2
             where S2.cName<>S1.cName);   

select sID,sName,sizeHS
from Student
where sizeHS> any(select sizeHS from Student);

select sID,sName,sizeHS
from Student S1
where exists (select *  from Student S2
             where S2.sizeHS<S1.sizeHS); 
             
select sID,sName
from Student
where sID =any(select sID from Apply where major='CS')
and not sID =any(select sID from Apply where major='EE');



--############################
--#############################

select sID,sName,GPA,GPA*(sizeHS/1000.0) as scaledGPA
from Student
where GPA*(sizeHS/1000.0)-GPA>1.0
or GPA-GPA*(sizeHS/1000.0)>1.0;

select sID,sName,GPA,GPA*(sizeHS/1000.0) as scaledGPA
from Student
where abs(GPA*(sizeHS/1000.0)-GPA)>1.0;

select *
from  (select sID,sName,GPA,GPA*(sizeHS/1000.0) as scaledGPA
from Student) G
where abs(G.scaledGPA)>1.0;


select distinct College.cName,state,GPA
from College,Apply,Student
where College.cName=Apply.cName
     and Apply.sID=Student.sID
     and GPA>=all
             (select GPA from Student,Apply
             where Student.sID=Apply.sID
             and Apply.cName=College.cName);


select cName,state,
(select distinct GPA
from Apply,Student
where College.cName=Apply.cName
     and Apply.sID=Student.sID
     and GPA>=all
             (select GPA from Student,Apply
             where Student.sID=Apply.sID
             and Apply.cName=College.cName))as GPA
from college;




select cName,state,
(select distinct sName
from Apply,Student
where College.cName=Apply.cName
     and Apply.sID=Student.sID)as sName
from college;

--##############################
--##############################

select distinct sName,major
from Student,Apply
where Student.sID=Apply.sID;

select distinct sName,major
from Student inner join Apply
on Student.sID=Apply.sID;


select sName,GPA
from Student,Apply
where Student.sID=Apply.sID
    and sizeHS<1000 and major='CS' and cName='Stanford';

select sName,GPA
from Student join Apply
on Student.sID=Apply.sID
where sizeHS<1000 and major='CS' and cName='Stanford';

select sName,GPA
from Student join Apply
on Student.sID=Apply.sID
and sizeHS<1000 and major='CS' and cName='Stanford';

select Apply.sID,sName,GPA,Apply.cName,enrollment
from Apply,Student,College
where Apply.sID=Student.sID and Apply.cName=College.cName;

select Apply.sID,sName,GPA,Apply.cName,enrollment
from Apply join Student  join College
on Apply.sID=Student.sID and Apply.cName=College.cName;

select Apply.sID,sName,GPA,Apply.cName,enrollment
from (Apply join Student on Apply.sID=Student.sID) join College
on Apply.cName=College.cName;


select distinct sName,major
from Student inner join Apply
on Student.sID=Apply.sID;

select distinct sName,major
from Student nature join Apply;


select sName,GPA
from Student natural join Apply
where sizeHS<1000 and major='CS' and cName='Stanford';

select sName,GPA
from Student join Apply using(sID)
where sizeHS<1000 and major='CS' and cName='Stanford';

select  S1.sID,S1.sName,S1.GPA,S2.sID,S2.sName,S2.GPA
from Student S1 join Student S2 using(GPA)
where  S1.sID<S2.sID;

select sName,sID,cName,major
from Student left outer join Apply using(sID);

select sName,sID,cName,major
from Student left join Apply using(sID);

select sName,sID,cName,major
from Student natural left join Apply;


select sName,sID,cName,major
from Student full outer join Apply using(sID);

select sName,sID,cName,major
from Student left outer join Apply using(sID)
union
select sName,sID,cName,major
from Student right outer join Apply using(sID);

--#####################################
--####################################Aggregation
/*
select A1,A2,...,An ----aggregation functions,min,max,sum,avg,count
from R1,R2,...,Rm
where condition
group by columns--new clause
having condition --new clause
*/

select *
from Student;

select avg(GPA)
from Student;

select min(GPA)
from Student,Apply
where Student.sID=Apply.sID and major='CS';

select avg(GPA)
from Student,Apply
where Student.sID=Apply.sID and major='CS';

select avg(GPA)
from Student
where sID in (select sID from Apply where major='CS');

select count(*)
from College
where enrollment>15000;

select count(*)
from Apply 
where cName='Cornell';


select count(distinct sID)
from Apply
where cName='Cornell';

select *
from Student S1
where (select count(*) from Student S2
      where S2.sID<>S1.sID and S2.GPA=S1.GPA)=
      (select count(*) from Student S2 
      where S2.sID<>S1.sID and S2.sizeHS=S1.sizeHS);
      


select CS.avgGPA-NonCS.avgGPA
from (select avg(GPA) as avgGPA from Student
     where sID in(
          select sID from Apply where major='CS'))as CS,
     (select avg(GPA) as avgGPA from Student
     where sID not in(
          select sID from Apply where major='CS'))as nonCS;

select (select avg(GPA) as avgGPA from Student
     where sID in(
          select sID from Apply where major='CS'))-
    (select avg(GPA) as avgGPA from Student
     where sID not in(
          select sID from Apply where major='CS'));
          
          
select cName,count(*)
from Apply
group by cName;

select state,sum(enrollment)
from College
group by state;

select cName,major, min(GPA),max(GPA)
from Student,Apply
where Student.sID=Apply.sID
group by cName,major;

select max(mx-mn)
from(
select cName,major, min(GPA) mn,max(GPA) mx
from Student,Apply
where Student.sID=Apply.sID
group by cName,major)M;


select Student.sID,count(distinct cName)
from Student,Apply
where Student.sID=Apply.sID
group by Student.sID;


select Student.sID,count(distinct cName)
from Student,Apply
where Student.sID=Apply.sID
group by Student.sID
union
select sID,0
from Student
where sID not in(select sID from Apply );

select cName
from Apply
group by cName
having count(*)<5;

select distinct  cName
from Apply A1
where 5>(select count(*) from Apply A2 where A2.cName=A1.cName);

select major
from Student,Apply
where Student.sID=Apply.sID
group by major
having max(GPA)<(select avg(GPA) from Student);

--#########################################
--##########################################


insert into Student values(432,'Kevin',null,1500);
insert into Student values(321,'Lori',null,2500);

select sID,sName,GPA
From Student
where GPA>3.5 or GPA<=3.5;

select count(distinct GPA)
from Student
where GPA is not null;

select distinct GPA
from Student;
--#############################
--#############################

/*
Insert Into table
values(A1,A2,...,An)

insert into table
select-statement
*/
/* deleting existing data
delete from table
where condition
*/
/*
update table
set attr=expression
where condition

update table
set A1=expr,A2=rxpre,..An=expr
where condition
*/

insert into College values('Carnegie Mellon','PA',11500);

insert into Apply
select sID,'Carnegie Mellon','CS',null
from Student
where sID not in(select sID from Apply);

insert into Apply
select sID,'Carnegie Mellon','EE','Y'
from Student
where sID not in(select sID from Apply where major='EE' 
   and decision='N');

delete from Student
where sID in
(select sID
from Apply
group by sID
having count(distinct major)>2
);


delete from Apply
where sID in 
(select sID
from Apply
group by sID
having count(distinct major)>2
);

select * from College
where cName not in (select cName from Apply where major='CS');


delete  from College
where cName not in (select cName from Apply where major='CS');

update Apply
set decision='Y',major='economics'
where cName='Carnegie Mellon'
and sID in (select sID from Student where GPA<3.6);


select * from Apply
where major='EE'
    and sID in
    (select sID from Student
    where GPA>=all
        ( select GPA from Student
        where sID in 
             ( select sID from Apply where major='EE')
        )
    );
    
update Apply
set major='CSE'
where major='EE'
    and sID in
    (select sID from Student
    where GPA>=all
        ( select GPA from Student
        where sID in 
             ( select sID from Apply where major='EE')
        )
    );
    
update Student
set GPA=(select max(GPA) from Student),
   sizeHS=(select min(sizeHS) from Student);
   
update Apply
set decision='Y';
