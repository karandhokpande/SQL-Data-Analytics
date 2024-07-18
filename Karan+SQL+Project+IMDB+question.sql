/* Hi Team, Kindly Import data From IMDB+dataset+import file*/

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*) Total_Rows FROM movie;
-- Total Row Count is 7997

SELECT count(*) Total_Rows FROM genre;
-- Total Row Count is 14662

SELECT count(*) Total_Rows FROM director_mapping;
-- Total Row Count is 3867

SELECT count(*) Total_Rows FROM role_mapping;
-- Total Row Count is 15615

SELECT count(*) Total_Rows FROM names;
-- Total Row Count is 25735

SELECT count(*) Total_Rows FROM ratings;
-- Total Row Count is 7997



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT * FROM movie;

SELECT 
		COUNT(*)-COUNT(ID) AS ID_nullcount, 
		COUNT(*)-COUNT(title) AS title_nullcount, 
		COUNT(*)-COUNT(year) AS year_nullcount,
		COUNT(*)-COUNT(date_published) AS date_published_nullcount,
		COUNT(*)-COUNT(duration) AS duration_nullcount,
		COUNT(*)-COUNT(country) AS country_null,
		COUNT(*)-COUNT(worlwide_gross_income) AS worlwide_gross_income_nullcount,
		COUNT(*)-COUNT(languages) AS languages_nullcount,
		COUNT(*)-COUNT(production_company) AS production_company_nullcount
FROM movie;
-- Four Columns is identified as Null COlumns i.e. Country, Worlwide_gross_income, languages, production_company.


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
SELECT * FROM movie;

-- Number of Movies Yearwise
SELECT year AS Year, COUNT(title) AS number_of_movies  FROM movie GROUP BY year;

-- Number of Movies Monthwise
SELECT month(date_published) AS month_num, COUNT(title) AS number_of_movies FROM movie 
	GROUP BY month_num
    ORDER BY month_num;	
   

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT  COUNT(title) AS Total_Number_of_Movies_Produced_By_India_USA_in_2019  FROM movie 
	WHERE year=2019 AND (country LIKE "%India%" OR country LIKE "%USA%");
-- Total Movies Count is dentified as 1059

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT(genre) AS Genres_List FROM genre;
-- Unique List of Genres is Extracted or Identified

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT * FROM movie;
SELECT * FROM genre;

SELECT genre AS Genres, Count(title) AS Total_Number_of_Movies from movie m
	INNER JOIN genre g ON m.id=g.movie_id
    GROUP BY genre
    ORDER BY Total_Number_of_Movies DESC
    LIMIT 1;
-- Drama genre has 4285 Movies which is the Highes count 




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

CREATE VIEW Genre_view AS SELECT count(movie_id), count(genre)
FROM genre GROUP BY movie_id HAVING count(genre)=1;
-- Created View for one genre movies
Select count(*) As Total_Number_of_Movies from Genre_view;
-- 3298 Movies is identified which belongs to one genre



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

SELECT genre , round(avg(duration),2) AS avg_duration from movie m
	INNER JOIN genre g ON m.id=g.movie_id
    GROUP BY genre
    ORDER BY avg_duration DESC;
-- Avg Duration for each Genre is Calculated


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

SELECT genre, Count(title) AS movie_count,
	RANK() OVER(ORDER BY Count(title) DESC) as genre_rank from movie m
	INNER JOIN genre g ON m.id=g.movie_id
    GROUP BY genre
    ORDER BY genre_rank;
   -- Thriller Genre Ranked 3rd in Movies production 
    


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

SELECT * FROM ratings;

SELECT  min(avg_rating) AS min_avg_rating, max(avg_rating) AS max_avg_rating,
		min(total_votes) AS min_total_votes, max(total_votes) AS max_total_votes,
        min(median_rating) AS min_median_rating, max(median_rating) AS max_median_rating
FROM ratings;
-- Min and Max is Calculated for all Columns-


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

SELECT * FROM movie;
SELECT * FROM ratings;
-- Data Tables is revisited
SELECT title, avg_rating,
	DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank from movie m
	INNER JOIN ratings r  ON m.id=r.movie_id
    limit 10;
-- Top 10 Movies is Ranked and identified



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

SELECT median_rating, count(movie_id) AS movie_count FROM ratings
GROUP BY median_rating
ORDER BY median_rating;
-- Median rating of 7 has Highest Movie Count of 2257


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

SELECT * FROM movie;
SELECT * FROM ratings;
-- Data Tables is revisited

SELECT production_company, count(id) AS movie_count,
	DENSE_RANK() OVER(ORDER BY COUNT(production_company) DESC) as prod_company_rank from movie m
	INNER JOIN ratings r  ON m.id=r.movie_id
    WHERE avg_rating > 8
    GROUP BY production_company
    LIMIT 10;
-- Dream Warrior Pictures & National Theatre Live Created most number of movies with Avg Rating Greater than 8




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

SELECT * FROM movie;
SELECT * FROM genre;
SELECT * FROM ratings;
-- Data Tables is revisited

-- Solution 1:- This Code will return output if USA will be one of many country
SELECT genre, count(id) AS movie_count from movie m
	INNER JOIN genre g ON m.id=g.movie_id
    INNER JOIN ratings r  ON m.id=r.movie_id
    WHERE year = 2017 AND MONTH(date_published)=3 AND total_votes > 1000 AND country LIKE "%USA%"
    GROUP BY genre
    ORDER BY movie_count DESC;

-- Solution 2:- This Code will return output if only USA country is involved and no other multiple country is present
SELECT genre, count(id) AS movie_count from movie m
	INNER JOIN genre g ON m.id=g.movie_id
    INNER JOIN ratings r  ON m.id=r.movie_id
    WHERE year = 2017 AND MONTH(date_published)=3 AND total_votes > 1000 AND country="USA"
    GROUP BY genre
    ORDER BY movie_count DESC;


 
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

SELECT title, avg_rating, genre FROM movie m
	INNER JOIN genre g ON m.id=g.movie_id
    INNER JOIN ratings r  ON m.id=r.movie_id
    WHERE avg_rating>8 AND title LIKE "The%"
    ORDER BY avg_rating DESC;
-- Extracted Movies starting with word "THE"

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(id) AS movies_count FROM movie m
    INNER JOIN ratings r  ON m.id=r.movie_id
    WHERE (date_published BETWEEN "2018-04-01" AND "2019-04-01") AND median_rating=8
    GROUP BY median_rating;
  -- 361 Movies is identified with median rating of 8  



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT * FROM movie;
SELECT * FROM ratings;
-- Data Tables is revisited

SELECT country, SUM(total_votes) AS Total_Votes from movie m
    INNER JOIN ratings r  ON m.id=r.movie_id
	WHERE country="Germany" OR country = "Italy"
    GROUP BY country;
-- Yes - German movies has more vote counts than Italian movies

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT * FROM names;
-- Data Tables is revisited

SELECT  COUNT(*)-COUNT(name) AS name_nulls, 
		COUNT(*)-COUNT(height) AS height_nulls, 
		COUNT(*)-COUNT(date_of_birth) AS date_of_birth_nulls, 
		COUNT(*)-COUNT(known_for_movies) AS known_for_movies_nulls
FROM names; 
-- 3 Columns has NULL valus i.e height, date_of_birth & known_for_movies

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

SELECT * FROM movie;
SELECT * FROM ratings;
SELECT * FROM names;
SELECT * FROM genre;
SELECT * FROM director_mapping;
-- Data Tables is revisited

CREATE VIEW Top_3_Genre AS 
	SELECT genre, Count(title) AS movie_count,
	RANK() OVER(ORDER BY Count(title) DESC) as genre_rank from movie m
	INNER JOIN genre g ON m.id=g.movie_id
    INNER JOIN ratings AS r ON r.movie_id = m.id
    WHERE avg_rating>8
    GROUP BY genre
    ORDER BY genre_rank
    limit 3;
-- Created View for Top 3 Genres with Rating more than 8
   
SELECT * FROM Top_3_Genre;

SELECT n.NAME AS director_name , Count(d.movie_id) AS movie_count FROM director_mapping AS d 
	INNER JOIN genre g USING (movie_id) 
	INNER JOIN names AS n ON n.id = d.name_id 
	INNER JOIN Top_3_Genre USING (genre) 
	INNER JOIN ratings USING (movie_id) WHERE avg_rating > 8 
	GROUP BY NAME 
	ORDER BY movie_count DESC 
	LIMIT 3 ;
-- Used Director Mapping and Extracted top 3 Directors



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

SELECT * FROM movie;
SELECT * FROM ratings;
SELECT * FROM names;
SELECT * FROM genre;
SELECT * FROM director_mapping;
SELECT * FROM role_mapping;
-- Data Tables is revisited

SELECT DISTINCT name AS actor_name, COUNT(r.movie_id) AS movie_count FROM ratings AS r
	INNER JOIN role_mapping AS rm ON rm.movie_id = r.movie_id
	INNER JOIN names AS n ON rm.name_id = n.id
	WHERE median_rating >= 8 AND category = 'actor'
	GROUP BY name
	ORDER BY movie_count DESC
	LIMIT 2;
 -- Top 2 Actors is extracted with Median Rating Greater Than and Equals to 8   


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

SELECT production_company, sum(total_votes) AS vote_count,
	DENSE_RANK() OVER(ORDER BY sum(total_votes) DESC) as prod_comp_rank from movie m
	INNER JOIN ratings r  ON m.id=r.movie_id
    GROUP BY production_company
    LIMIT 3;
-- Top 3 Production Houses is extracted


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

SELECT * FROM movie;
SELECT * FROM ratings;
SELECT * FROM names;
SELECT * FROM genre;
SELECT * FROM director_mapping;
SELECT * FROM role_mapping;
-- Data Tables is revisited

CREATE VIEW Top_actor AS
	( SELECT NAME AS actor_name, Sum(total_votes) AS total_votes, Count(rm.movie_id) AS movie_count, 
    Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating FROM role_mapping rm 
    INNER JOIN names n ON rm.name_id = n.id 
    INNER JOIN ratings r ON rm.movie_id = r.movie_id 
    INNER JOIN movie m ON rm.movie_id = m.id 
    WHERE category = 'actor' AND country LIKE '%India%' 
    GROUP BY name_id, 
    NAME HAVING Count(DISTINCT rm.movie_id) >= 5);
-- Created Top Actor View

SELECT * FROM Top_actor;

SELECT *, DENSE_Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank FROM Top_actor;
-- List of top Indian Actor

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


SELECT n.name, Sum(total_votes) AS total_votes, COUNT(m.id) AS movie_count, 
	Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating, 
	DENSE_RANK() OVER(ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) DESC) AS actress_rank 
	FROM names n 
	INNER JOIN role_mapping rm ON n.id = rm.name_id 
	INNER JOIN movie m ON rm.movie_id = m.id 
	INNER JOIN ratings r ON m.id = r.movie_id 
	WHERE rm.category = "ACTRESS" AND m.languages LIKE "%Hindi%" AND m.country = "INDIA" 
	GROUP BY n.name 
	HAVING COUNT(m.id) >=3 
    LIMIT 5;
-- Top 5  actresses in Hindi movies is extracted

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title,r.avg_rating,
	CASE 
		WHEN avg_rating > 8 THEN 'Superhit movies'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
		WHEN avg_rating < 5 THEN 'Flop movies'
	END AS avg_rating_category FROM movie AS m
	INNER JOIN genre AS g ON m.id=g.movie_id
	INNER JOIN ratings AS r ON m.id=r.movie_id
	WHERE genre='thriller'
	ORDER BY r.avg_rating DESC;
-- Movies Are Categorised


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

SELECT genre, ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre) AS moving_avg_duration FROM movie AS m 
	INNER JOIN genre AS g  ON m.id= g.movie_id
	GROUP BY genre
	ORDER BY genre;


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
CREATE VIEW top_three_genre AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies FROM genre AS g
    INNER JOIN movie AS m ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
);
-- Top 3 Generes is Calculated
SELECT * FROM top_three_genre;

CREATE VIEW top_5 AS
(
	SELECT genre, year, title AS movie_name, worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank FROM movie AS m 
    INNER JOIN genre AS g ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_three_genre)
);
-- Top 5 Movies data is Calculated
SELECT * FROM top_5;

SELECT * FROM top_5
WHERE movie_rank<=5;
-- Here movies rank is filtered out


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

SELECT production_company ,count(m.id)AS movie_count, 
	RANK() OVER(ORDER BY count(id) DESC) AS prod_comp_rank FROM movie AS m
	INNER JOIN ratings AS r ON m.id=r.movie_id
	WHERE median_rating>=8 AND production_company IS NOT NULL AND position(',' IN languages)>0
	GROUP BY production_company
	LIMIT 2;
-- Start Cinmas and Twenttieth Century Production Companies ideantified


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


SELECT name as actress_name, SUM(total_votes) AS total_votes, COUNT(rm.movie_id) as movie_id, 
		Round(Sum(avg_rating * total_votes)/Sum(total_votes),2) AS actress_avg_rating, 
		DENSE_RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank FROM names n 
	INNER JOIN role_mapping rm ON n.id = rm.name_id 
	INNER JOIN ratings r ON r.movie_id = rm.movie_id 
	INNER JOIN genre g ON g.movie_id = r.movie_id 
	WHERE category="actress" AND avg_rating>8 AND g.genre="Drama" 
	GROUP BY name 
	LIMIT 3;



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

CREATE VIEW  movie_data AS
(
	SELECT d.name_id,NAME,d.movie_id,duration,r.avg_rating,total_votes,m.date_published,
			Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published 
			FROM director_mapping AS d
           INNER JOIN names  AS n ON n.id = d.name_id
           INNER JOIN movie AS m ON  m.id = d.movie_id
           INNER JOIN ratings AS r ON r.movie_id = m.id );
-- Collected Movie Data details required
 SELECT * FROM movie_data;
 
CREATE VIEW Date_Diff AS
(
       SELECT *,Datediff(next_date_published, date_published) AS date_difference FROM  movie_data );

SELECT * FROM  Date_Diff;	

    SELECT  name_id AS director_id,
			NAME AS director_name,
			Count(movie_id) AS number_of_movies,
			Round(Avg(date_difference),2) AS avg_inter_movie_days,
			Round(Avg(avg_rating),2)  AS avg_rating,
			Sum(total_votes) AS total_votes,
			Min(avg_rating) AS min_rating,
			Max(avg_rating) AS max_rating,
			Sum(duration) AS total_duration FROM Date_Diff
		GROUP BY director_id
		ORDER BY Count(movie_id) DESC 
		LIMIT 9;
-- Top 9 Director data is Extracted

