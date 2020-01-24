
// Actor CSV
CREATE CONSTRAINT ON (a:Actor) ASSERT a.actorid IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///actors.csv" AS row
FIELDTERMINATOR ';'
CREATE (a:Actor {actorid: row.actorid, name: row.name, sex: row.sex})

// Director CSV
CREATE CONSTRAINT ON (d: Director) ASSERT d.directorid IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///directors.csv" AS row
FIELDTERMINATOR ';'
Merge (d:Director {directorid: row.directorid, name: row.name, rate: toFloat(row.rate), gross: toFloat(row.gross), num:toInt(row.num)})


// WRITER CSV
CREATE CONSTRAINT ON (w: Writer) ASSERT w.writerid IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///writers.csv" AS row
FIELDTERMINATOR ';'
Merge (w:Writer {writerid: row.writerid, name: row.name})


// Movie CSV
CREATE CONSTRAINT ON (m:Movie) ASSERT m.movieid IS UNIQUE;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///movies.csv" AS row
FIELDTERMINATOR ';'
Merge (m:Movie {movieid: row.movieid, title: row.title, year: toInteger(row.year)})



// <--------------------------------JOINS------------------------------------>


//Movie - Actor
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///moviestoactors.csv" AS row
FIELDTERMINATOR ';'
MATCH (a:Actor), (m:Movie)
WHERE  row.movieid = m.movieid
AND    row.actorid = a.actorid
CREATE (a)-[:ACTED_IN{as_character: row.as_character, leading: toInteger(row.leading)}]->(m)



// Movie - Director
CREATE CONSTRAINT ON (g:Genre) ASSERT g.name IS UNIQUE;


USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///moviestodirectors.csv" AS row
FIELDTERMINATOR ';'
MERGE (g:Genre{name: row.genre})


USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///moviestodirectors.csv" AS row
FIELDTERMINATOR ';'
MATCH (d:Director), (m:Movie), (g:Genre)
WHERE  row.movieid = m.movieid
AND    row.directorid = d.directorid
AND    row.genre = g.name
CREATE (d)-[:DIRECTED]->(m)-[:BELONGS_TO]->(g)


// Movie Writer
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///moviestowriters.csv" AS row
FIELDTERMINATOR ';'
MATCH (w:Writer), (m:Movie)
WHERE  row.movieid = m.movieid
AND    row.writerid = w.writerid
CREATE (w)-[:WROTE{addition: row.addition}]->(m)



// Ratings
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///ratings.csv" AS row
FIELDTERMINATOR ';'
MATCH  (m:Movie)
WHERE  row.movieid = m.movieid
CREATE (m)-[:HAS_BEEN_GIVEN]->(r:Rating{rank:toFloat(row.rank), votes:toInteger(row.votes), distribution: toInt(row.distribution)})



// Running Times
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///runningtimes.csv" AS row
FIELDTERMINATOR ';'
MATCH  (m:Movie)
WHERE  row.movieid = m.movieid
CREATE (m)-[:RUNS_FOR]->(t:Time{time:row.time, addition:row.addition, time1: toInt(row.time1)})




//<-------------------QUERYS-------------------------->

//1) 
MATCH (a:Actor)
WHERE a.sex = "F"
RETURN COUNT(a)




//2)
MATCH (d:Director)-[r:DIRECTED]->(m:Movie)
WITH count(r) as c,m
WHERE c>6
return m.title as Title, c as Number_of_Directors


//3)
//https://community.neo4j.com/t/pairs-of-actors-with-their-movies-where-they-acted-in-more-than-one-movie-together/4068/2

MATCH (p1)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2)
WHERE id(p1) < id(p2)
WITH p1, p2, collect(m) as commonMovies
WHERE size(commonMovies) > 10
RETURN p1.name as Actor_1, p2.name  as Actor_2, size(commonMovies) as Num_of_movies_costarred_in



//https://markhneedham.com/blog/2015/05/19/neo4j-finding-all-shortest-paths/
//4) 
MATCH (a1:Actor), (a2:Actor),
path = shortestpath((a1)-[*]-(a2))
WHERE a1.name contains "McGregor, Ewan" AND a2.name contains "Hamill, Mark"
RETURN path


