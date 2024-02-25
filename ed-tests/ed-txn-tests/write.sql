\set i random(1,1000000)
\set j random(1,1000000)
--insert into data values(:i, :j);
update data set value = :j where key = :i;
