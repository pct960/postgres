\set i random(1,1000000)
\set j random(1,1000000)
update data set value = :j where key = :i;
