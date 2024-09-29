create table t1 (id serial primary key not null, data int);
insert into t1(data) values(generate_series(1, 1000000));

