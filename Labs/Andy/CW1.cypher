
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
// Merge 


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

32896


//2)
MATCH (d:Director)-[r:DIRECTED]->(m:Movie)
WITH count(r) as c,m
WHERE c>6
return m.title as Title, c as Number_of_Directors

╒════════════════════════╤═════════════════════╕
│"Title"                 │"Number_of_Directors"│
╞════════════════════════╪═════════════════════╡
│"Fantasia/2000 (1999)"  │8                    │
├────────────────────────┼─────────────────────┤
│"Fantasia (1940)"       │11                   │
├────────────────────────┼─────────────────────┤
│"Bambi (1942)"          │7                    │
├────────────────────────┼─────────────────────┤
│"Pinocchio (1940)"      │7                    │
├────────────────────────┼─────────────────────┤
│"Dumbo (1941)"          │7                    │
├────────────────────────┼─────────────────────┤
│"Duel in the Sun (1946)"│7                    │
└────────────────────────┴─────────────────────┘
//3)
//https://community.neo4j.com/t/pairs-of-actors-with-their-movies-where-they-acted-in-more-than-one-movie-together/4068/2

MATCH (p1)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2)
WHERE id(p1) < id(p2)
WITH p1, p2, collect(m) as commonMovies
WHERE size(commonMovies) > 10
RETURN p1.name as Actor_1, p2.name  as Actor_2, size(commonMovies) as Num_of_movies_costarred_in

╒══════════════════╤═════════════════╤════════════════════════════╕
│"Actor_1"         │"Actor_2"        │"Num_of_movies_costarred_in"│
╞══════════════════╪═════════════════╪════════════════════════════╡
│"Lynn, Sherry (I)"│"McGowan, Mickie"│11                          │
├──────────────────┼─────────────────┼────────────────────────────┤
│"McGowan, Mickie" │"Angel, Jack (I)"│11                          │
├──────────────────┼─────────────────┼────────────────────────────┤
│"Lynn, Sherry (I)"│"Angel, Jack (I)"│12                          │
└──────────────────┴─────────────────┴────────────────────────────┘


//https://markhneedham.com/blog/2015/05/19/neo4j-finding-all-shortest-paths/
//4) 
MATCH (a1:Actor), (a2:Actor),
path = shortestpath((a1)-[*]-(a2))
WHERE a1.name contains "McGregor, Ewan" AND a2.name contains "Hamill, Mark"
RETURN path


















// -------------------------------------------------------------------------------ALEX DBS

// 1) 
MATCH (a:Actors)
WHERE a.Sex = "F"
RETURN COUNT(a)

32896


//2)
MATCH (d:Directors)-[r:DIRECTED]->(m:Movies)
WITH count(r) as c,m
WHERE c>6
return m.Title as Title, c as Number_of_Directors


╒════════════════════════╤═════════════════════╕
│"Title"                 │"Number_of_Directors"│
╞════════════════════════╪═════════════════════╡
│"Fantasia (1940)"       │11                   │
├────────────────────────┼─────────────────────┤
│"Fantasia/2000 (1999)"  │8                    │
├────────────────────────┼─────────────────────┤
│"Bambi (1942)"          │7                    │
├────────────────────────┼─────────────────────┤
│"Dumbo (1941)"          │7                    │
├────────────────────────┼─────────────────────┤
│"Duel in the Sun (1946)"│7                    │
├────────────────────────┼─────────────────────┤
│"Pinocchio (1940)"      │7                    │
└────────────────────────┴─────────────────────┘

//3

MATCH (p1)-[:ACTED_IN]->(m:Movies)<-[:ACTED_IN]-(p2)
WHERE id(p1) < id(p2)
WITH p1, p2, collect(m) as commonMovies
WHERE size(commonMovies) > 10
RETURN p1.Name as Actor_1, p2.Name  as Actor_2, size(commonMovies) as Num_of_movies_co_starred_in

╒══════════════════╤══════════════════╤═════════════════════════════╕
│"Actor_1"         │"Actor_2"         │"Num_of_movies_co_starred_in"│
╞══════════════════╪══════════════════╪═════════════════════════════╡
│"Angel, Jack (I)" │"Lynn, Sherry (I)"│12                           │
├──────────────────┼──────────────────┼─────────────────────────────┤
│"Lynn, Sherry (I)"│"McGowan, Mickie" │11                           │
├──────────────────┼──────────────────┼─────────────────────────────┤
│"Angel, Jack (I)" │"McGowan, Mickie" │11                           │
└──────────────────┴──────────────────┴─────────────────────────────┘


MATCH (a1:Actors), (a2:Actors),
path = shortestpath((a1)-[*]-(a2))
WHERE a1.Name contains "McGregor, Ewan" AND a2.Name contains "Hamill, Mark"
RETURN path

│[{"Sex":"M","ActorID":1035771,"Name":"McGregor, Ewan"},
{"AsCharacter":│
│"[Curt Wild]  <1>","Leading":1},
{"Year":1998,"Title":"Velvet Goldmine │
│(1998)","MovieID":2542878},
{"Year":1998,"Title":"Velvet Goldmine (1998│
│)","MovieID":2542878},{}

{"Time1":124,"Addition":"","Time":"124"},{"Ti│
│me1":124,"Addition":"","Time":"124"},{},{"Year":1980,"Title":"Star War│
│s: Episode V - The Empire Strikes Back (1980)","MovieID":2371786},{"Ye│
│ar":1980,"Title":"Star Wars: Episode V - The Empire Strikes Back (1980│
│)","MovieID":2371786},{"AsCharacter":"[Luke Skywalker]  <1>","Leading"│
│:1},{"Sex":"M","ActorID":638959,"Name":"Hamill, Mark (I)"}]   



// cp -a /home/andy/.config/'Neo4j Desktop'/Application/neo4jDatabases/database-0971a7a6-b868-452a-ada5-bbba23b1e080/installation-3.5.14/import/. /home/andy/.config/'Neo4j Desktop'/Application/neo4jDatabases/database-225d0794-cc05-44fa-b2d9-aa39803526b7/installation-3.5.14/import