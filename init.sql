create table data (key int primary key, value int);

-- Use this for durability-costs and ed-txn-latency tests
insert into data values(generate_series(1,1000000),generate_series(1,1000000));

-- Use this for contention tests
--insert into data values(generate_series(1,250),generate_series(1,250));
