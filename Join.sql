-- Show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid, player FROM goal
  WHERE teamid = 'GER'
/*
From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
Show id, stadium, team1, team2 for just game 1012
*/
SELECT id,stadium,team1,team2
  FROM game WHERE id = 1012;

-- Show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
  FROM game g JOIN goal g2 ON (g.id = g2.matchid)
  WHERE g2.teamid = 'GER';

-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
 FROM game g JOIN goal g2 ON g.id = g2.matchid
 WHERE player LIKE 'Mario%';

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal g JOIN eteam e ON g.teamid = e.id
  WHERE gtime <= 10;

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
 FROM game g JOIN eteam e ON g.team1 = e.id
 WHERE coach = 'Fernando Santos';

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
 FROM goal g JOIN game g2 ON g.matchid = g2.id
 WHERE g2.stadium = 'National Stadium, Warsaw',

-- Show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id
  WHERE player NOT IN (SELECT player FROM goal WHERE teamid = 'GER')
  AND (team1 = 'GER' OR team2 = 'GER')

SELECT DISTINCT player
 FROM game JOIN goal ON matchid = id
 WHERE teamid != 'GER' AND (team1 = 'GER' OR team2 = 'GER')

-- Show teamname and the total number of goals scored.
SELECT teamname, COUNT(gtime)
  FROM eteam JOIN goal ON id=teamid
  GROUP BY teamname;

-- Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(gtime)
 FROM goal g JOIN game g2 ON g.matchid = g2.id
 GROUP BY stadium;

-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(player)
  FROM game g JOIN goal g2 ON g.id= g2.matchid
  WHERE (g.team1 = 'POL' OR g.team2 = 'POL')
  GROUP BY g2.matchid, g.mdate;

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(player)
 FROM goal g JOIN game g2 ON g.matchid = g2.id
 WHERE g.teamid = 'GER'
 GROUP BY g.matchid, g2.mdate;

/*
List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
...
Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0.
You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.
*/
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1, team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
  FROM game g LEFT JOIN goal g2 ON g2.matchid = g.id
  GROUP BY g.mdate, g.team1, g.team2
  ORDER BY g.mdate, g.matchid, g.team1, g.team2;
-- LEFT JOIN because there are matches which there was no goal in.

--  Select the code which shows players, their team and the amount of goals they scored against Greece(GRE).
SELECT player, teamid, COUNT(*)
  FROM game JOIN goal ON matchid = id
  WHERE (team1 = 'GRE' OR team2 = 'GRE')
  AND teamid != 'GRE'
  GROUP BY player, teamid

-- Select the code which would show the player and their team for those who have scored against Poland(POL) in National Stadium, Warsaw.
SELECT DISTINCT player, teamid
  FROM game JOIN goal ON matchid = id
  WHERE stadium = 'National Stadium, Warsaw'
  AND (team1 = 'POL' OR team2 = 'POL')
  AND teamid != 'POL'

 -- Select the code which shows the player, their team and the time they scored, for players who have played in Stadion Miejski (Wroclaw) but not against Italy(ITA).
 SELECT DISTINCT player, teamid, gtime
  FROM game JOIN goal ON matchid = id
  WHERE stadium = 'Stadion Miejski (Wroclaw)'
  AND (( teamid = team2 AND team1 != 'ITA') OR ( teamid = team1 AND team2 != 'ITA'))
