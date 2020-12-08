-- Show the athelete (who) and the country name for medal winners in 2000.
SELECT who, country.name
 FROM ttms JOIN country ON (ttms.country=country.id)
 WHERE games = 2000

-- Show the who and the color of the medal for the medal winners from 'Sweden'.
SELECT who, color
 FROM ttms t JOIN country c ON t.country = c.id
 WHERE c.name = 'Sweden';

-- Show the years in which 'China' won a 'gold' medal.
SELECT games
 FROM ttms t JOIN country c ON t.country = c.id
 WHERE c.name = 'China' AND t.color = 'gold';

-- Show who won medals in the 'Barcelona' games.
SELECT who
 FROM ttws t JOIN games g ON t.games = g.yr
 WHERE g.city = 'Barcelona';

-- Show which city 'Jing Chen' won medals. Show the city and the medal color.
SELECT city, color
 FROM ttws t JOIN games g ON t.games = g.yr
 WHERE t.who = 'Jing Chen';

 -- Show who won the gold medal and the city.
 SELECT who, city
  FROM ttws t JOIN games g ON t.games = g.yr
  WHERE t.color = 'gold';

-- Show the games and color of the medal won by the team that includes 'Yan Sen'.
SELECT games, color
 FROM ttmd t JOIN team t2 ON t.team  = t2.id
 WHERE t2.name = 'Yan Sen';

-- Show the 'gold' medal winners in 2004.
SELECT name
 FROM ttmd t JOIN team t2 ON t.team = t2.id
 WHERE t.color = 'gold' AND games = 2004;

-- Show the name of each medal winner country 'FRA'.
SELECT name
 FROM ttmd t JOIN team t2 ON t.team = t2.id
 WHERE t.country = 'FRA';
