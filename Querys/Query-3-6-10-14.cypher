//Q3
match (a:Actors {Sex: "F"})
with count(a) as Female
match (b:Actors {Sex: "M"})
with Female, count(b) as Male
return Male, Female

//Male	Female
//65794	32896



//q6
match (m:Movies)<-[:ACTED_IN]-(a:Actors) where a.Name contains "Ewan" and a.Name contains "McGregor"
match (m)<-[:ACTED_IN]-(b:Actors) where b.Name contains "Robert" and b.Name contains "Carlyle"
return m.Title as Film

//Film
//"Trainspotting (1996)"
//"Being Human (1994)"


//q10
match (m:Movies)<-[:ACTED_IN]-(a:Actors {Sex: "F"})
with m, count(a) as Females
match (m)<-[:ACTED_IN]-(b:Actors {Sex: "M"})
with m, Females, count(b) as Males
where  Females > Males
return count(distinct m) as Number_movies

//324


//Q14
match (d:Directors)-[:DIRECTED]->(m:Movies)<-[:ACTED_IN]-(a:Actors) 
where a.Name = d.Name
return count(distinct m) as Movie

//497

//or - get same answer but maby better?

match (d:Directors)-[:DIRECTED]->(m:Movies)<-[:ACTED_IN]-(a:Actors) 
where split(a.Name, ", ")[0] =  split(d.Name, ", ")[0] and split(a.Name, ", ")[-1] =   split(d.Name, ", ")[-1] 
return count(m) as Movie 


