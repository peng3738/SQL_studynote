--################################
--################################SQL Social-Network Modification Exercises 
--Q1；It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
delete from highschooler 
where grade=12

--Q2：If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
delete from likes 
where id1 in (select F.id1 from friend F where F.id1=likes.id1 and F.id2=likes.id2)
and id1 not  in(select AB.id2 from
likes AB 
where AB.id1=likes.id2 )；

--Q3：For all cases where A is friends with B, and B is friends with C, 
--add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 

insert into friend
select distinct AB.id1, BC.id2
from Friend AB, Friend BC
where AB.id2=BC.id1 and AB.id1!=BC.id2 and (not exists (select * from friend AC where AC.id1=AB.id1 and AC.id2=BC.id2))；

