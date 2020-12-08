-- How many stops are in the database.
SELECT COUNT(id)
 FROM stops;

-- Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops
 WHERE name = 'Craiglockhart';

-- Give the id and the name for the stops on the '4' 'LRT' service.
SELECT s.id, s.name
 FROM stops s JOIN route r ON s.id = r.stop
 WHERE r.company = 'LRT' AND r.num = '4';

/* Run the query and notice the two services that link these stops have a count of 2.
Add a HAVING clause to restrict the output to these two routes.*/
SELECT company, num, COUNT(*)
 FROM route WHERE stop=149 OR stop=53
 GROUP BY company, num
 HAVING COUNT(*) > 1;

/*Execute the self join shown and observe that b.stop gives all the places
you can get to from Craiglockhart, without changing routes.*/
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  a.company=b.company AND a.num=b.num
WHERE a.stop = 53 AND b.stop = (SELECT id FROM stops WHERE name = 'London Road');

/*The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number.
Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
If you are tired of these places try 'Fairmilehead' against 'Tollcross'*/
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  a.company=b.company AND a.num=b.num
  JOIN stops stopa ON a.stop=stopa.id
  JOIN stops stopb ON b.stop=stopb.id
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  a.company=b.company AND a.num=b.num
WHERE a.stop = 115 AND b.stop = 137;

-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num
FROM route a JOIN route b ON
  a.company=b.company AND a.num=b.num
  JOIN stops stopa ON a.stop=stopa.id
  JOIN stops stopb ON b.stop=stopb.id
WHERE stopa.name='Craiglockhart' AND stopb.name = 'Tollcross';

/*Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus,
including 'Craiglockhart' itself, offered by the LRT company.
Include the company and bus no. of the relevant services.*/
SELECT DISTINCT stopb.name, a.company, a.num
FROM route a JOIN route b ON
  a.company=b.company AND a.num=b.num
  JOIN stops stopa ON a.stop=stopa.id
  JOIN stops stopb ON b.stop=stopb.id
WHERE stopa.name='Craiglockhart' AND a.company = 'LRT';

/*Find the routes involving two buses that can go from Craiglockhart to Lochend.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.*/
SELECT DISTINCT c.num,c.company,stops.name,l.num,l.company
FROM
(SELECT num,company,stop FROM route WHERE (num,company) IN
(SELECT num,company FROM route JOIN stops ON (route.stop = stops.id)
			WHERE stops.NAME='Craiglockhart')
) AS c

JOIN

(SELECT num,company,stop FROM route WHERE (num,company) IN
(SELECT num,company FROM route JOIN stops ON (route.stop = stops.id)
			WHERE stops.NAME='Lochend')) AS l
ON c.stop = l.stop JOIN stops ON c.stop = stops.id
ORDER BY c.num, stops.name, l.num;

-- Select the code that would show it is possible to get from Craiglockhart to Haymarket
SELECT DISTINCT a.name, b.name
  FROM stops a JOIN route z ON a.id=z.stop
  JOIN route y ON y.num = z.num
  JOIN stops b ON y.stop=b.id
 WHERE a.name='Craiglockhart' AND b.name ='Haymarket'

 -- Select the code that shows the stops that are on route.num '2A' which can be reached with one bus from Haymarket?
 SELECT S2.id, S2.name, R2.company, R2.num
   FROM stops S1, stops S2, route R1, route R2
  WHERE S1.name='Haymarket' AND S1.id=R1.stop
    AND R1.company=R2.company AND R1.num=R2.num
    AND R2.stop=S2.id AND R2.num='2A'

-- Select the code that shows the services available from Tollcross?
SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
 WHERE stopa.name='Tollcross'
