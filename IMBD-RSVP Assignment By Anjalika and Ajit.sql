USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT Count(*) AS count_director_mapping FROM director_mapping; 
-- count 3867
SELECT Count(*) AS count_genre FROM genre; 
-- count 14662
SELECT Count(*) AS count_movie FROM movie; 
-- count 14662
SELECT Count(*) AS count_names FROM names; 
-- count 25735
SELECT Count(*) AS count_ratings FROM ratings; 
-- count 7997
SELECT Count(*) AS count_role FROM role_mapping;
-- count 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company
FROM   movie ;

-- country,worldwide_gross_income,languages,production_company has null values

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT year,
       Count(title) AS number_of_movies
FROM   movie
GROUP  BY year; 

-- in 2017 3052 movies released
-- in 2018 2944 movies released
-- in 2019 2019 movies released

SELECT Month(date_published) AS month_num,
       Count(title)          AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY  number_of_movies desc;

--

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(title) AS no_of_movies
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%India%' )
       AND year = 2019; 


-- 1059 movies from both India and USA in the year 2019
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT( genre )
FROM   genre; 
-- 13 types of genre.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT Count(*),
       genre
FROM   imdb.genre
GROUP  BY genre limit 1;


-- Genre Drama has more number movies with a number of 4285.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH one_genre_movie
     AS (SELECT Count(movie_id) no_of_movies
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(movie_id) = 1)
SELECT Sum(no_of_movies)
FROM   one_genre_movie ;

-- there are 3289 movies which has one one genre.

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)



/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
	   Round(Avg(duration), 2)AS average_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY average_duration DESC; 

-- Action movies has an average duration of 112.88 minutes.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH movie_genre_rank
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                Rank ()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS movie_rank
         FROM   genre g
         GROUP  BY genre)
SELECT *
FROM   movie_genre_rank
WHERE  genre = 'Thriller'; 

-- Thriller movie is the 3rd most movies produced with 1484 number of movies.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS min_median_rating
FROM   ratings; 

  

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT     m.title,
           r.avg_rating,
           Rank() OVER(ORDER BY r.avg_rating DESC) AS movie_rank
FROM       movie                                   AS m
INNER JOIN ratings r
ON         m.id=r.movie_id limit 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_company_rank
     AS (SELECT m.production_company,
                Count(m.id)                  AS movie_count,
                Rank()
                  OVER (
                    ORDER BY Count(id) DESC) AS prod_com_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  r.avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   prod_company_rank
WHERE  prod_com_rank = 1 ;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
       Count(g.movie_id) AS movie_count
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  Month(m.date_published) = 3
       AND m.year = 2017
       AND m.country LIKE( '%USA%' )
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY movie_count DESC; 

-- Genre Drama has 24 movies in march 2017 in USA.


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title,
       r.avg_rating,
       g.genre
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN genre AS g
               ON g.movie_id = m.id
WHERE  r.avg_rating > 8
       AND m.title LIKE 'The%';


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(*)
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND r.median_rating = 8;
       
-- 361 movies released in between '2018-04-01' AND '2019-04-01'

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT Sum(r.total_votes) total_votes,
       m.country
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  m.country = 'Germany'
       or m.country = 'Italy'
GROUP  BY m.country; 


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN n.NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN n.height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN n.date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN n.known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies
FROM   names n; 

-- There are 17335 null value in height coloum,13431 null value in date of birth and 15226 null values in known for movies 

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS
(
           SELECT     g.genre AS genre,
                     
                      Count(g.movie_id) AS movie_count
           FROM       genre g
           INNER JOIN ratings r
           ON         g.movie_id = r.movie_id
           WHERE      r.avg_rating>8
           GROUP BY   g.genre
           ORDER BY   movie_count DESC limit 3 )
SELECT     n.NAME            AS director_name,
           Count(d.movie_id) AS movie_count
FROM       director_mapping d
INNER JOIN names n
ON         n.id=d.name_id
INNER JOIN ratings r
ON         r.movie_id=d.movie_id
INNER JOIN genre gen
ON         gen.movie_id = r.movie_id
WHERE      r.avg_rating>8
AND  gen.genre in(select genre from top_3_genre)
GROUP BY   director_name
ORDER BY   movie_count DESC limit 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name,
       Count(role_m.movie_id) as movie_count
FROM   names n
       INNER JOIN role_mapping AS role_m
               ON role_m.name_id = n.id
       INNER JOIN ratings AS rate
               ON rate.movie_id = role_m.movie_id
WHERE  rate.median_rating >= 8 and role_m.category='actor'
group by n.name
ORDER  BY movie_count desc limit 2;

-- Mammootty and Mohanlal is in the list


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company ,
           Sum(ratings.total_votes)                             AS vote_count,
           Rank() OVER (ORDER BY Sum(ratings.total_votes) DESC) AS prod_comp_rank
FROM       movie
INNER JOIN ratings
ON         ratings.movie_id=movie.id
GROUP BY   production_company limit 3;

    -- Marvel Studios,Twentieth Century Fox,Warner Bros. are top 3 production house

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_actors
     AS (SELECT names.NAME              actor_name,
                sum(ratings.total_votes) as total_votes,
                Count(ratings.movie_id) AS movie_count,
                Round(Sum(ratings.avg_rating * ratings.total_votes) /
                      Sum(ratings.total_votes),
                2)                      AS actor_avg_rating
         FROM   names
                INNER JOIN role_mapping
                        ON role_mapping.name_id = names.id
                INNER JOIN ratings
                        ON ratings.movie_id = role_mapping.movie_id
                INNER JOIN movie
                        ON movie.id = ratings.movie_id
         WHERE  movie.country = 'India'
                AND role_mapping.category = 'ACTOR'
         GROUP  BY actor_name
         ORDER  BY actor_avg_rating DESC)
SELECT *,
       Rank ()
         OVER (
           ORDER BY actor_avg_rating DESC) as actor_rank
FROM   top_actors
WHERE  movie_count >= 5 limit 1;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_actress
     AS (SELECT names.NAME              actor_name,
                Sum(ratings.total_votes) as total_votes,
                Count(ratings.movie_id) AS movie_count,
                Round(Sum(ratings.avg_rating * ratings.total_votes) /
                      Sum(ratings.total_votes),
                2)                      AS actor_avg_rating
         FROM   names
                INNER JOIN role_mapping
                        ON role_mapping.name_id = names.id
                INNER JOIN ratings
                        ON ratings.movie_id = role_mapping.movie_id
                INNER JOIN movie
                        ON movie.id = ratings.movie_id
         WHERE  movie.country = 'India'
         and movie.languages like  '%hindi%'
                AND role_mapping.category = 'actress'
         GROUP  BY actor_name
         ORDER  BY actor_avg_rating DESC)
SELECT *,
       Rank ()
         OVER (
           ORDER BY actor_avg_rating DESC) as actress_rank	
FROM   top_actress
WHERE  movie_count >= 3 limit 5;

-- top 5 actress are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT distinct m.title,
       r.avg_rating average_rating,
       CASE
         WHEN r.avg_rating > 8 THEN 'Superhit movies'
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit Movies'
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'flop movies'
       END          AS movie_catogory
FROM   movie AS m
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
       INNER JOIN genre AS g
               ON g.movie_id = m.id
WHERE  g.genre = 'thriller'
ORDER  BY r.avg_rating DESC ;



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:



SELECT g.genre,
       Round(Avg(m.duration), 2)                         AS avg_duration,
       SUM(Round(Avg(m.duration), 2))
         over(
           ORDER BY g.genre ROWS unbounded preceding)    AS
       running_total_duration,
       Round(Avg(Round(Avg(m.duration), 2))
               over(
                 ORDER BY g.genre ROWS 10 preceding), 2) AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY g.genre order by avg_duration;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies




WITH top_3_genre AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies
    FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),
top_5 AS
(
	SELECT genre,
			year,
			title AS movie_name,
			CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) as worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))   DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_3_genre)
)

SELECT *
FROM top_5
WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company,
       Count(*) AS movie_count,
       rank() over(order by Count(*) desc) as prod_comp_rank
FROM   movie
       inner join ratings
               ON movie.id = ratings.movie_id
WHERE  production_company IS NOT NULL
       AND median_rating >= 8
       AND Position(',' IN languages) > 0
       group by production_company
       order by movie_count desc
       limit 2;
-- Star Cinema and Twentieth Century Fox has more number of movie count.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT     n.NAME as actress_name,
           sum(r.total_votes) as total_votes,
           Count(r.movie_id)                                                AS movie_count,
           Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating,
           Rank () OVER(ORDER BY Count(r.movie_id) DESC)                    AS actress_rank
FROM       ratings                                                          AS r
INNER JOIN role_mapping                                                     AS map
ON         map.movie_id = r.movie_id
INNER JOIN names AS n
ON         n.id = map.name_id
INNER JOIN genre AS g
ON         g.movie_id = r.movie_id
WHERE      g.genre = 'drama'
AND        map.category='actress'
AND        r.avg_rating>8
GROUP BY   n.NAME
ORDER BY   movie_count DESC limit 3;


-- top 3 actress based on number of Super Hit movies (average rating >8) in drama genre are Parvathy Thiruvothu,Susan Brown and Amanda Lawrence.



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH movie_date_info AS
(
         SELECT   d.name_id,
                  NAME,
                  d.movie_id,
                  m.date_published,
                  Lead(date_published, 1) OVER(partition BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
         FROM     director_mapping d
         JOIN     names AS n
         ON       d.name_id=n.id
         JOIN     movie AS m
         ON       d.movie_id=m.id ), date_difference AS
(
       SELECT *,
              Datediff(next_movie_date, date_published) AS diff
       FROM   movie_date_info ), avg_inter_days AS
(
         SELECT   name_id,
                  Avg(diff) AS avg_inter_movie_days
         FROM     date_difference
         GROUP BY name_id ), final_result AS
(
         SELECT   d.name_id                   AS director_id,
                  NAME                        AS director_name,
                  Count(d.movie_id)           AS number_of_movies,
                  Round(avg_inter_movie_days) AS inter_movie_days,
                  Round(Avg(avg_rating),2)    AS avg_rating,
                  Sum(total_votes)            AS total_votes,
                  Min(avg_rating)             AS min_rating,
                  Max(avg_rating)             AS max_rating,
                  Sum(duration)               AS total_duration
         FROM     names            AS n
         JOIN     director_mapping AS d
         ON       n.id=d.name_id
         JOIN     ratings AS r
         ON       d.movie_id=r.movie_id
         JOIN     movie AS m
         ON       m.id=r.movie_id
         JOIN     avg_inter_days AS a
         ON       a.name_id=d.name_id
         GROUP BY director_id
         ORDER BY Count(d.movie_id) DESC )
SELECT *
FROM   final_result LIMIT 9;



