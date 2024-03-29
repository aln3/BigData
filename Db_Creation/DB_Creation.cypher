CREATE CONSTRAINT ON (a:Actors) ASSERT a.ActorID IS UNIQUE;

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///actors.csv" AS row FIELDTERMINATOR ';'
MERGE (a:Actors {ActorID: row.actorid})
ON CREATE SET a.ActorID = toInteger(row.actorid), a.Name= row.name, a.Sex= row.sex


CREATE CONSTRAINT ON (d:Directors) ASSERT d.DirectorID IS UNIQUE;

LOAD CSV WITH HEADERS FROM "file:///directors.csv" AS row FIELDTERMINATOR ';'
MERGE (d:Directors {DirectorID: row.directorid})
ON CREATE SET d.DirectorID= toInteger(row.directorid), d.Name= row.name, d.Rate= toFloat(row.rate), d.Gross= toFloat(row.gross), d.Num= toInteger(row.num)

CREATE CONSTRAINT ON (w:Writers) ASSERT w.WriterID IS UNIQUE; 

LOAD CSV WITH HEADERS FROM "file:///writers.csv" AS row FIELDTERMINATOR ';'
MERGE (w:Writers {WriterID: row.writerid})
ON CREATE SET w.WriterID= toInteger(row.writerid), w.Name= row.name

CREATE CONSTRAINT ON (m:Movies) ASSERT m.MovieID IS UNIQUE; 

LOAD CSV WITH HEADERS FROM "file:///movies.csv" AS row FIELDTERMINATOR ';'
MERGE (m:Movies {MovieID: row.movieid})
ON CREATE SET m.MovieID= toInteger(row.movieid), m.Title= row.title, m.Year= toInteger(row.year)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///moviestoactors.csv" AS row FIELDTERMINATOR ';'
MATCH (a:Actors {ActorID: toInteger(row.actorid)}),
  (m:Movies {MovieID: toInteger(row.movieid)})
CREATE (a)-[:ACTED_IN{AsCharacter: row.as_character, Leading: toInteger(row.leading)}]->(m)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///moviestodirectors.csv" AS row FIELDTERMINATOR ';'
MATCH (d:Directors {DirectorID: toInteger(row.directorid)}),
  (m:Movies {MovieID: toInteger(row.movieid)})
CREATE (d)-[:DIRECTED]->(m)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///moviestowriters.csv" AS row FIELDTERMINATOR ';'
MATCH (w:Writers {WriterID: toInteger(row.writerid)}),
  (m:Movies {MovieID: toInteger(row.movieid)})
CREATE (w)-[:WROTE{Additon: row.addition}]->(m)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///moviestodirectors.csv" AS row FIELDTERMINATOR ';'
MERGE (g:Genre { name: row.genre }) 
MERGE (m:Movies {MovieID: toInteger(row.movieid)})
MERGE (m)-[:BELONGS_TO]->(g)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///ratings.csv" AS row FIELDTERMINATOR ';'
MERGE (r:Rating {Rank: toFloat(row.rank), Votes: toInteger(row.votes), Distribution: row.distribution}) 
MERGE (m:Movies {MovieID: toInteger(row.movieid)})
MERGE (m)-[:HAS_BEEN_GIVEN]->(r)

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///runningtimes.csv" AS row FIELDTERMINATOR ';'
MERGE (t:RunningTime {Time: row.time, Addition: row.addition, Time1: toInteger(row.time1)}) 
MERGE (m:Movies {MovieID: toInteger(row.movieid)})
MERGE (m)-[:RUNS_FOR]->(t)

=========================================================================================================================
///////checking staff////////////////////////////////////////////////////////////////////////
MATCH (m:Movies)-[b:BELONGS_TO]->(g:Genre)
WHERE g.name CONTAINS "Crime"
return m,b,g LIMIT 10

MATCH (m:Movies)-[b:BELONGS_TO]->(g:Genre)
WHERE g.name=''
return m,b,g

MATCH (m:Movies)
WHERE NOT (m)-[:BELONGS_TO]->(:Genre)
return m,count(*)

MATCH p=(a:Actors)-[:ACTED_IN]->(m:Movies)-[:BELONGS_TO]->(g:Genre)
WHERE a.Name= "Peck, Gregory" 
RETURN p


call db.schema.visualization


