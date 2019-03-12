--######################################
--######################################SQL Movie-Rating Modification Exercises 
--Q1：Add the reviewer Roger Ebert to your database, with an rID of 209. 
insert into reviewer
values(209,'Roger Ebert')

--Q2：Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
INSERT INTO Rating
SELECT Rating.rID,Movie.mID,5,NULL
FROM Rating,Reviewer,Movie
WHERE Rating.rID=Reviewer.rID and name='James Cameron' 

--Q3：For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) 
UPdate Movie
Set year=year+25
where mID in (select mID
from rating
group by mID 
having avg(stars)>=4)

--Q4：Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
delete from Rating
where Rating.mID in(
select Rating.mID
FROM Rating, Movie
WHERE movie.mID=rating.mID and (year<1970 or year>2000))
and stars<4
