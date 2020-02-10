// 1) 
MATCH (a:Actors)
WHERE a.Sex = "F"
RETURN COUNT(a)

// 32896


// 4)
MATCH (d:Directors)-[r:DIRECTED]->(m:Movies)
WITH count(r) as c,m
WHERE c>6
return m.Title as Title, c as Number_of_Directors


// ╒════════════════════════╤═════════════════════╕
// │"Title"                 │"Number_of_Directors"│
// ╞════════════════════════╪═════════════════════╡
// │"Fantasia (1940)"       │11                   │
// ├────────────────────────┼─────────────────────┤
// │"Fantasia/2000 (1999)"  │8                    │
// ├────────────────────────┼─────────────────────┤
// │"Bambi (1942)"          │7                    │
// ├────────────────────────┼─────────────────────┤
// │"Dumbo (1941)"          │7                    │
// ├────────────────────────┼─────────────────────┤
// │"Duel in the Sun (1946)"│7                    │
// ├────────────────────────┼─────────────────────┤
// │"Pinocchio (1940)"      │7                    │
// └────────────────────────┴─────────────────────┘

// 8)

MATCH (p1)-[:ACTED_IN]->(m:Movies)<-[:ACTED_IN]-(p2)
WHERE id(p1) < id(p2)
WITH p1, p2, collect(m) as commonMovies
WHERE size(commonMovies) > 10
RETURN p1.Name as Actor_1, p2.Name  as Actor_2, size(commonMovies) as Num_of_movies_co_starred_in

// ╒══════════════════╤══════════════════╤═════════════════════════════╕
// │"Actor_1"         │"Actor_2"         │"Num_of_movies_co_starred_in"│
// ╞══════════════════╪══════════════════╪═════════════════════════════╡
// │"Angel, Jack (I)" │"Lynn, Sherry (I)"│12                           │
// ├──────────────────┼──────────────────┼─────────────────────────────┤
// │"Lynn, Sherry (I)"│"McGowan, Mickie" │11                           │
// ├──────────────────┼──────────────────┼─────────────────────────────┤
// │"Angel, Jack (I)" │"McGowan, Mickie" │11                           │
// └──────────────────┴──────────────────┴─────────────────────────────┘

// 12)

MATCH (a1:Actors), (a2:Actors),
path = shortestpath((a1)-[*]-(a2))
WHERE a1.Name contains "McGregor, Ewan" AND a2.Name contains "Hamill, Mark"
RETURN path

// │[{"Sex":"M","ActorID":1035771,"Name":"McGregor, Ewan"},
// {"AsCharacter":│
// │"[Curt Wild]  <1>","Leading":1},
// {"Year":1998,"Title":"Velvet Goldmine │
// │(1998)","MovieID":2542878},
// {"Year":1998,"Title":"Velvet Goldmine (1998│
// │)","MovieID":2542878},{}

// {"Time1":124,"Addition":"","Time":"124"},{"Ti│
// │me1":124,"Addition":"","Time":"124"},{},{"Year":1980,"Title":"Star War│
// │s: Episode V - The Empire Strikes Back (1980)","MovieID":2371786},{"Ye│
// │ar":1980,"Title":"Star Wars: Episode V - The Empire Strikes Back (1980│
// │)","MovieID":2371786},{"AsCharacter":"[Luke Skywalker]  <1>","Leading"│
// │:1},{"Sex":"M","ActorID":638959,"Name":"Hamill, Mark (I)"}]   