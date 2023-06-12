create table data (key serial primary key not null, value int);
insert into data(value) values(generate_series(1, 1000000));

