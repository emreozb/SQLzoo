-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962;

-- Give year of 'Citizen Kane'.
SELECT yr FROM movie
 WHERE title = 'Citizen Kane';

 /* List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title).
 Order results by year. */
 SELECT id, title, yr
  FROM movie
  WHERE title LIKE 'Star Trek%'
  ORDER BY yr;

-- What id number does the actor 'Glenn Close' have?
SELECT id FROM actor
 WHERE name = 'Glenn Close';

 -- What is the id of the film 'Casablanca'
 SELECT id FROM movie
  WHERE title = 'Casablanca';

-- Obtain the cast list for 'Casablanca'.
SELECT a.name
  FROM casting c JOIN actor a ON c.actorid = a.id
  WHERE movieid = (SELECT id FROM movie
                   WHERE title = 'Casablanca');

-- Obtain the cast list for the film 'Alien'
SELECT a.name
 FROM casting c JOIN actor a ON c.actorid = a.id
 WHERE c.movieid = (SELECT id FROM movie
                     WHERE title = 'Alien');

-- List the films in which 'Harrison Ford' has appeared
SELECT m.title
 FROM movie m
 JOIN casting c ON m.id = c.movieid
 JOIN actor a ON c.actorid = a.id
 WHERE a.name = 'Harrison Ford';

 SELECT m.title
 FROM casting c
 JOIN movie m ON m.id = c.movieid
 WHERE c.actorid LIKE (SELECT id FROM actor WHERE name = 'Harrison Ford');

 /* List the films where 'Harrison Ford' has appeared - but not in the starring role.
[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] */
SELECT m.title
 FROM movie m
 JOIN casting c ON m.id = c.movieid
 JOIN actor a ON c.actorid = a.id
 WHERE a.name = 'Harrison Ford' AND c.ord > 1;

-- List the films together with the leading star for all 1962 films.
SELECT m.title, a.name
 FROM movie m
 JOIN casting c ON m.id = c.movieid
 JOIN actor a ON c.actorid = a.id
 WHERE c.ord = 1 AND m.yr = 1962;

/* Which were the busiest years for 'Rock Hudson', show the year and the number
of movies he made each year for any year in which he made more than 2 movies.*/
SELECT yr, COUNT(title)
 FROM movie m
 JOIN casting c ON m.id = c.movieid
 JOIN actor a ON c.actorid = a.id
 WHERE a.name = 'Rock Hudson'
 GROUP BY m.yr
 HAVING COUNT(title) > 2;

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT m.title, a.name
 FROM movie m
 JOIN casting c ON m.id = c.movieid
 JOIN actor a ON c.actorid = a.id
 WHERE c.ord = 1 AND m.id IN (SELECT movieid FROM casting c
                                 JOIN actor a ON c.actorid = a.id
                                 WHERE a.name = 'Julie Andrews');
-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT a.name
 FROM movie m
 JOIN casting c ON m.id = c.movieid
 JOIN actor a ON c.actorid = a.id
 WHERE c.ord = 1
 GROUP BY a.name
 HAVING COUNT(m.title) >= 15;

 -- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
 SELECT m.title, COUNT(c.actorid)
 FROM movie m
 JOIN casting c ON m.id = c.movieid
 WHERE m.yr = 1978
 GROUP BY m.title
 ORDER BY COUNT(c.actorid) DESC, title;

-- List all the people who have worked with 'Art Garfunkel'.
SELECT a.name
 FROM casting c
 JOIN actor a ON c.actorid= a.id
 WHERE a.name != 'Art Garfunkel' AND c.movieid IN (SELECT movieid FROM casting c
                       JOIN actor a ON c.actorid = a.id
                       WHERE a.name = 'Art Garfunkel');

-- Select the statement which lists the unfortunate directors of the movies which have caused financial loses (gross < budget)
SELECT name
 FROM actor INNER JOIN movie ON actor.id = director
 WHERE gross < budget;

-- Select the statement that shows the list of actors called 'John' by order of number of movies in which they acted
SELECT name, COUNT(movieid)
 FROM casting JOIN actor ON actorid=actor.id
 WHERE name LIKE 'John %'
 GROUP BY name ORDER BY 2 DESC;

-- Select the statement that lists all the actors that starred in movies directed by Ridley Scott who has id 351
SELECT name
 FROM movie JOIN casting ON movie.id = movieid
 JOIN actor ON actor.id = actorid
 WHERE ord = 1 AND director = 351;

-- There are two sensible ways to connect movie and actor. They are:
link the director column in movies with the primary key in actor
connect the primary keys of movie and actor via the casting table
