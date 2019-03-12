--######################################
--######################################SQL movie-rating query exercise
/*
Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
*/

--Q1:Find the titles of all movies directed by Steven Spielberg. 

SELECT title
FROM Movie
WHERE director='Steven Spielberg';

--Q2:Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
SELECT *
FROM Movie,Rating
WHERE Movie.mID=Rating.mID AND
    stars=4 OR stars=5
ORDER BY year ASC;

--Q3:Find the titles of all movies that have no ratings. 
SELECT title
FROM Movie
WHERE mID NOT IN (SELECT DISTINCT Rating.mID 
      FROM Rating);
	  
--Q4:Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT name
FROM Reviewer,Rating
WHERE Reviewer.rID=Rating.rID and ratingDate IS NULL; 

--Q5:Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate.
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT name,title,stars,ratingDate
FROM Reviewer, Rating,Movie
WHERE Reviewer.rID=Rating.rID and Movie.mID=Rating.mID
ORDER BY name,title,stars;

--Q6: For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
-- return the reviewer's name and the title of the movie. 

SELECT name,title
FROM Reviewer,Movie, (
    SELECT DISTINCT R1.rID,R1.mID
    FROM Rating R1,Rating R2
    Where R1.rID=R2.rID and R1.mID=R2.mID and R1.stars<R2.stars and R1.ratingDate<R2.ratingDate
) as A
WHERE Reviewer.rID=A.rID and Movie.mID=A.mID;

--Q7:For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. 
--Sort by movie title. 

SELECT  title, R.maxs
FROM Movie,(SELECT DISTINCT mID,max(stars) as maxs 
FROM Rating
GROUP BY mID
) as R
WHERE Movie.mID=R.mID 
ORDER BY title;


--Q8:For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
--Sort by rating spread from highest to lowest, then by movie title.

SELECT title, R.ratingSpread
FROM Movie,(SELECT mID,max(stars)-min(stars) as ratingSpread
FROM Rating
GROUP BY mID
) as R
WHERE Movie.mID=R.mID
ORDER BY R.ratingSpread DESC,title;

--Q9:Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
--Don't just calculate the overall average rating before and after 1980.) 

SELECT avg(B1980.avgs)-avg(A1980.avgs)
FROM  (SELECT Movie.mID,year,avg(stars) as avgs
FROM Movie,Rating
WHERE Movie.mID=Rating.mID and year<1980 
GROUP BY Movie.mID
) as B1980,
(SELECT Movie.mID,year,avg(stars) as avgs
FROM Movie,Rating
WHERE Movie.mID=Rating.mID and year>1980 
GROUP BY Movie.mID) as A1980;
