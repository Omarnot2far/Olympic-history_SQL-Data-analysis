SELECT * FROM olympic.athlete_events;

-- 1.How many olympics games have been held?
SELECT COUNT(DISTINCT Games) AS num_olympic_games
FROM olympic.athlete_events;


-- 2.List down all Olympics games held so far? 
SELECT DISTINCT Games, Year, Season, City
FROM olympic.athlete_events;

-- 3.Mention the total no of nations who participated in each olympics game?
SELECT Games, COUNT(DISTINCT NOC) AS num_participating_nations
FROM olympic.athlete_events
GROUP BY Games;

-- 4.Which year saw the highest no of countries participating in olympics?
SELECT 'Year with the highest number of participating nations' AS description, Year, COUNT(DISTINCT NOC) AS num_participating_nations
FROM olympic.athlete_events
GROUP BY Year
ORDER BY num_participating_nations DESC
LIMIT 1;

-- 5.-- 4.Which year saw the lowest no of countries participating in olympics?
SELECT 'Year with the lowest number of participating nations' AS description, Year, COUNT(DISTINCT NOC) AS num_participating_nations
FROM olympic.athlete_events
GROUP BY Year
ORDER BY num_participating_nations ASC
LIMIT 1;

-- 6.Which nation has participated in all of the olympic games?

SELECT NOC, COUNT(DISTINCT Games) AS num_games_participated
FROM olympic.athlete_events
GROUP BY NOC
HAVING num_games_participated =(SELECT COUNT(DISTINCT Games) FROM olympic.athlete_events); 

-- 7.Identify the sport which was played in all summer olympics.
SELECT Sport, COUNT(DISTINCT Year) AS num_years_played
FROM olympic.athlete_events
WHERE Season = 'Summer'
GROUP BY Sport
HAVING num_years_played = (SELECT COUNT(DISTINCT Year) FROM olympic.athlete_events WHERE Season = 'Summer');

-- 8.Which Sports were just played only once in the olympics?
SELECT Sport, COUNT(DISTINCT Year) AS num_years_played
FROM olympic.athlete_events
GROUP BY Sport
HAVING num_years_played = 1;

-- 9.Fetch the total no of sports played in each olympic games?
SELECT Games, count(distinct Sport) AS no_sports
FROM olympic.athlete_events
GROUP BY Games
order by Games;

-- 10.Fetch details of the oldest athletes to win a gold medal before 1990?
SELECT distinct Name, Year
FROM olympic.athlete_events
WHERE Medal='Gold' and Year <1900
order by Year; 

-- 11.Find the Ratio of male and female athletes participated in all olympic games?

SELECT Games,
       COUNT(CASE WHEN Sex = 'M' THEN 1 END) AS num_male_athletes,
       COUNT(CASE WHEN Sex = 'F' THEN 1 END) AS num_female_athletes,
       COUNT(*) AS total_athletes,
       ROUND(COUNT(CASE WHEN Sex = 'M' THEN 1 END) / COUNT(*), 2) AS male_ratio,
       ROUND(COUNT(CASE WHEN Sex = 'F' THEN 1 END) / COUNT(*), 2) AS female_ratio
FROM olympic.athlete_events
GROUP BY Games
ORDER BY Games;

-- 12.Fetch the top 5 athletes who have won the most gold medals?

SELECT Name, COUNT(*) AS num_gold_medals
FROM olympic.athlete_events
WHERE Medal = 'Gold'
GROUP BY Name
ORDER BY num_gold_medals DESC
LIMIT 5;

-- 13.Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)?
SELECT Name, COUNT(*) AS num_medals
FROM olympic.athlete_events
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Name
ORDER BY num_medals DESC
LIMIT 5; 

-- 14.Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won?
SELECT Team, COUNT(*) AS num_medals
FROM olympic.athlete_events
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Team
ORDER BY num_medals DESC
LIMIT 5; 

-- 15.List down total gold, silver and broze medals won by each country?
SELECT Team,
	COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold,
    COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver,
    COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze,
    COUNT(*) AS num_medals
FROM olympic.athlete_events
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Team
order by Gold desc, Silver desc, Bronze desc;

-- 16.List down total gold, silver and broze medals won by each country corresponding to each olympic games?
SELECT Team, 
       Year, 
       Medal, 
       COUNT(*) AS num_medals
FROM olympic.athlete_events
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Team, Year, Medal
ORDER BY Year ASC; 

-- 17.Which countries have never won gold medal but have won silver/bronze medals?

SELECT DISTINCT t1.NOC, t2.region
FROM olympic.athlete_events t1
JOIN olympic.noc_regions t2 ON t1.NOC = t2.NOC
WHERE t1.Medal IN ('Silver', 'Bronze')
AND t1.NOC NOT IN (
    SELECT NOC
    FROM athlete_events
    WHERE Medal = 'Gold'
)
ORDER BY t1.NOC ASC;

-- 18.In which Sport/event, India has won highest medals.
SELECT Sport, Event, COUNT(*) AS num_medals
FROM olympic.athlete_events
WHERE NOC = 'IND' AND Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Sport, Event
ORDER BY num_medals DESC
LIMIT 1;

-- 19.Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
SELECT t1.Year, t1.City, t1.Season, t1.Event, t1.Medal
FROM olympic.athlete_events t1
JOIN olympic.noc_regions t2 ON t1.NOC = t2.NOC
WHERE t1.Sport = 'Hockey' AND t1.NOC = 'IND' AND t1.Medal IS NOT NULL
ORDER BY t1.Year ASC; 