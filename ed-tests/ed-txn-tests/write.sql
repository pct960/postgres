\set i random(1,250)
\set j random(1,250)
--insert into tinydata values(:i, :j);
update tinydata set value = :j where key = :i;
