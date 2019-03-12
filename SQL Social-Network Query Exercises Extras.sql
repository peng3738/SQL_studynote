--################################
--################################SQL Social-Network Query Exercises Extras 
--Q1：For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
SELECT A.name,A.grade,B.name,B.grade,C.name,C.grade
FROM Likes AB,Likes BC,Highschooler A,Highschooler B,Highschooler C
WHERE AB.ID2=BC.ID1 and AB.ID1 !=BC.ID2 and A.ID=AB.ID1 and B.ID=AB.ID2 and C.ID=BC.ID2

--Q2：Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
SELECT distinct A.name,A.grade
FROM Highschooler as A,Friend
Where A.ID=ID1 and A.grade not in 
(SELECT B.grade
FROM Highschooler B,Friend AB
WHERE AB.ID1=A.ID and AB.ID2=B.ID)

--Q3：What is the average number of friends per student? (Your result should be just one number.) 
SELECT avg(Num)
FROM (SELECT count(ID2) as Num 
FROM Friend
GROUP By ID1) 

--Q4：Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
SELECT count(A.IDNew)
FROM
(SELECT Friend.ID2 as IDNew
FROM (SELECT ID2 from Friend,Highschooler
WHERE ID1=ID and name='Cassandra') as FirstFriend, Friend
WHERE Friend.ID1 =FirstFriend.ID2
UNION
SELECT ID2 from 
Friend,Highschooler 
WHERE ID1=ID and name='Cassandra') A,Highschooler
WHERE A.IDNew=ID and name!='Cassandra'

--Q5：Find the name and grade of the student(s) with the greatest number of friends. 
SELECT name,grade
From Highschooler,Friend
WHERE ID1=ID
GROUP By ID1
Having count(ID2)=(
SELECT Max(NumFriend.Num)
FROM 
(SELECT ID1,count(ID2) as Num  FROM Friend 
group by ID1) as NumFriend,Friend)
