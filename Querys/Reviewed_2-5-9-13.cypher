//===================QUERIES CHECK==============================//



// 2) OK
MATCH (a:Actors)
WHERE a.Sex="M"
RETURN count(a) AS No_Of_Male_Actors

// 5) OK - Check's all t1s even if miltiples exist
MATCH (m:Movies)-[t:RUNS_FOR]->(r:RunningTime)
WHERE r.Time1 < 10
RETURN count(m) AS No_Of_Movies_Less_than_10min


// 9 OK but maybe more concise with 9b?

//Alex's Query 9a
UNWIND [{start: 1960, end: 1969}, 
{start: 1970, end: 1979}, 
{start: 1980, end: 1989}, 
{start: 1990, end: 1999}, 
{start: 2000, end: 2010}] AS row
WITH row.start AS StartingYear, row.end AS EndingYear
MATCH (m:Movies)
WHERE m.Year >= StartingYear and m.Year <= EndingYear
RETURN StartingYear + "-" + EndingYear AS Decade, count(m) AS No_Of_Movies
ORDER BY Decade

// 9b
// [REF]https://dzone.com/articles/neo4j-cypher-finding-movies
// Less complicated query
// Though slightly different for the last decade wich has 11 years - think this is a typo 
WITH startDecade, startDecade + 9 as endDecade
MATCH (m:Movies)
WHERE m.Year >= startDecade and m.Year <= endDecade
RETURN startDecade + "-" + endDecade as Year, count(m) as Number_of_Movies_Released
ORDER BY Year


// 13
MATCH (a:Actors)-[:ACTED_IN]->(m:Movies)-[:BELONGS_TO]->(g:Genre)
WITH a.Name AS Actor ,COUNT (DISTINCT g.name) AS No_Of_Genres
WHERE No_Of_Genres >= 10
RETURN  Actor,No_Of_Genres

// My check - both answeres the same
MATCH path = (a:Actors)-[:ACTED_IN]->(m:Movies)-[:BELONGS_TO]->(g:Genre)
WITH COUNT(DISTINCT g.name) AS num,a 
WHERE num >= 10
RETURN a.Name, num;
