--####################################
--####################################
/*
Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
 
*/

--Q1:Find the names of all students who are friends with someone named Gabriel. 
SELECT distinct name
FROM Highschooler,Friend
WHERE ID in(SELECT distinct ID2
from FRIEND,Highschooler
WHERE Highschooler.ID=ID1 and name='Gabriel');


--Q2:For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
SELECT distinct s1.name,s1.grade,s2.name,s2.grade
FROM Highschooler s1,Highschooler s2,Likes
WHERE s1.ID=ID1 and s2.ID=ID2 and s1.grade>=s2.grade+2;

--Q3:For every pair of students who both like each other, return the name and grade of both students. Include each pair only once,
-- with the two names in alphabetical order. 

SELECT H1.name,H1.grade,H2.name,H2.grade
FROM Likes G1,Likes G2,Highschooler H1,Highschooler H2
WHERE G1.ID1=H1.ID and G1.ID2=H2.ID and H1.name<H2.name and G1.ID2=G2.ID1 and G1.ID1=G2.ID2;

--Q4:Find all students who do not appear in the Likes table (as a student who likes or is liked) 
--and return their names and grades. Sort by grade, then by name within each grade. 
SELECT name,grade
FROM Highschooler
WHERE ID not IN(SELECT ID1
FROM Likes
union
SELECT ID2
FROM Likes)
ORDER BY grade,name;

--Q5:For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), 
--return A and B's names and grades. 
SELECT H1.name,H1.grade,H2.name,H2.grade
FROM Highschooler H1, Highschooler H2,Likes
WHERE ID1=H1.ID and ID2=H2.ID and ID2 not in (SELECT ID1 FROM Likes);

--Q6:Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
SELECT distinct name,grade
FROM Highschooler,Friend,
(SELECT distinct ID1,count(*) as effect 
FROM Friend,Highschooler H1,Highschooler H2
WHERE H1.ID=ID1 and H2.ID=ID2 and H2.grade=H1.grade
group by ID1 ) as G1,
(SELECT distinct ID1,count(*) as effect 
FROM Friend,Highschooler H1,Highschooler H2
WHERE H1.ID=ID1 and H2.ID=ID2
group by ID1) as G2
WHERE G1.ID1=G2.ID1 and G1.effect=G2.effect and Id=G1.ID1 
order by grade,name

--Q7:For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
--For all such trios, return the name and grade of A, B, and C. 
SELECT distinct A.name,A.grade,B.name,B.grade,C.name,C.grade
FROM Highschooler A,Highschooler B,Highschooler C,Friend AB,Friend,Likes
WHERE Likes.ID1=A.ID and Likes.ID2=B.ID and Friend.ID1=C.ID and AB.ID1=A.ID and B.ID not in (SELECT ID2 FROM Friend WHERE 
ID1=A.ID) and B.ID in(SELECT ID2 FROM Friend WHERE ID1=C.ID) and A.ID in(SELECT ID2 FROM Friend WHERE ID1=C.ID);

--Q8:Find the difference between the number of students in the school and the number of different first names. 
SELECT (SELECT count(*) 
FROM Highschooler)-(SELECT count (*)
FROM (SELECT count (*) FROM Highschooler 
group by name) ) 

--Q9:Find the name and grade of all students who are liked by more than one other student. 
SELECT distinct name,grade
FROM Highschooler,Likes as B
WHERE B.ID2=ID and (SELECT count(*) FROM Likes WHERE B.ID2=ID2 )>1
