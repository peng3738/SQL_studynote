--#############################
--############################SQL Movie-Rating Query Exercises Extras
--Q1:Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT name
FROM Reviewer,(SELECT rID
FROM Rating
WHERE mID IN(SELECT mID
FROM Movie
WHERE title='Gone with the Wind'
)) as R
WHERE Reviewer.rID=R.rID

--Q2:For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT name,title,stars
FROM Movie,Reviewer,Rating
WHERE name in (SELECT DISTINCT director
FROM Movie) and Reviewer.rID=Rating.rID and Movie.mID=Rating.mID;

--Q3:Return all reviewer names and movie names together in a single list, alphabetized. 
--(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 

SELECT name
FROM Reviewer
UNION 
SELECT title
FROM Movie
ORDER BY name,title;

--Q4:Find the titles of all movies not reviewed by Chris Jackson. 
SELECT title
FROM Movie
WHERE  Movie.mID  not IN
(SELECT Rating.mID
FROM Rating,Reviewer
WHERE Reviewer.rID=Rating.rID and Reviewer.name='Chris Jackson')

--Q5:For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
SELECT DISTINCT R1.name,R2.name
FROM (SELECT Rating.rID as rid1,Rating.mID as mid1,name 
FROM Rating,Reviewer
WHERE Rating.rID=Reviewer.rID)as R1,(SELECT Rating.rID as rid2,Rating.mID as mid2,name 
FROM Rating,Reviewer
WHERE Rating.rID=Reviewer.rID)as R2
WHERE R1.mid1=R2.mid2 and R1.name<R2.name;

--Q6:For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
SELECT name,title,stars
FROM Movie,Rating,Reviewer
WHERE stars in (SELECT DISTINCT min(stars) FROM Rating) and Reviewer.rID=Rating.rID and Movie.mID=Rating.mID;

--Q7:List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
SELECT title,R.avg_rating
FROM Movie,(SELECT Rating.mID as midr,avg(stars) as avg_rating
FROM Rating
GROUP BY mID) as R
WHERE Movie.mID=R.midr
ORDER BY R.avg_rating DESC,title;


--Q8:Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
SELECT name
FROM Reviewer,(SELECT DISTINCT rID as ridr,count(rID) as Ncount
FROM Rating
GROUP BY ridr) as R
WHERE R.Ncount>=3 and R.ridr=Reviewer.rid;

--Q9:Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 

SELECT title,Movie.director
FROM Movie,(SELECT director,count(director) as Ncount
FROM Movie
Group by director) as R
WHERE Movie.director=R.director and R.Ncount>1
ORDER BY Movie.director,title

--Q10:Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
--(Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
SELECT title,avg(stars) as Avg
FROM Movie,Rating
WHERE Movie.mID=Rating.mID
GROUP BY Movie.mID
HAVING Avg in 
(SELECT max(R.ave_rating) FROM 
(SELECT avg(stars) as ave_rating
FROM Rating
GROUP BY mID) AS R )

--Q11:Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
--(Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
SELECT title,avg(stars)
FROM Movie,Rating
WHERE Movie.mID=Rating.mID
Group by Rating.mID
Having avg(stars) in 
( SELECT min(R.avgrating)
 FROM (SELECT avg(stars) as avgrating
 FROM Rating 
 GROUP BY mID) as R);
 
 --Q12:For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. 
 --Ignore movies whose director is NULL. 
 SELECT DISTINCT  director,title, max(stars)
FROM Rating,Movie
WHERE Rating.mID=Movie.mID and director is not NULL
GROUP BY director
