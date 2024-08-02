create table data (key int primary key, value int);
create table tinydata (key int primary key, value int);

-- Used for durability-costs and ed-txn-latency tests
insert into data values(generate_series(1,1000000),generate_series(1,1000000));

-- Used for contention tests
insert into tinydata values(generate_series(1,250),generate_series(1,250));
