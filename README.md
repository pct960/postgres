# Eventually Durable PostgreSQL

For latency-critical transactional applications, durability is often what 
limits performance.   That is, executing transactions is fast, but guaranteeing
that they are durable is slow.   As a result, most of each transaction's latency
is attributable to durability.   To address this problem, some database systems
allow applications to sacrifice durability guarantees in exchange for lower
transaction latencies.   These ad hoc techniques are effective at reducing
latencies, but they can make it difficult for applications to understand
and manage the risks associated with failures.

In the Eventual Durability paper, our goal is to offer a more principled foundation for these
kinds of performance/durability tradeoffs.   The major obstacle to doing this
is the transaction model itself because it couples transaction durability with
transaction commit.   That is, the model defines a single point at which a 
transaction becomes visible and durable.   This forces all transaction guarantees
to wait for the slowest one, which is often durability.

The primary contribution of this work is a new, _eventually durable_ transaction
model, which decouples commit from durability.   Transactions commit first, and 
become durable later.   We argue for making this model the basis of the contract
between transactional data systems and applications.   We describe what it means to
correctly implement eventually durable applications and consider how they can be
exposed to applications.   

This repository contains the source code for the prototype implementation of eventual
durability in Postgres, and it was forked from version 15.1 of community Postgres. The experiments 
in the paper use this prototype to show that it enables applications to reduce transaction 
latencies while managing durability risks.

## Compiling and Running

Simply run:
```
./configure --prefix=<INSTALL_DIR>
make && make install
```
where `<INSTALL_DIR>` is where you want the PosgreSQL binaries to be installed.

## Configuration
The scripts included in the `ed-tests` directory of this repository can be used to reproduce the results shown in the paper. 
All tests need one `PRIMARY` instance, one `STANDBY` instance, and a test client.
These can run on separate servers, or on the same server for local testing.
At least five compute nodes are needed to fully 
reproduce all results.

Before running any tests, edit `vars.txt` to define your testing configuration.
Use `primary` and `standby` to specify the IP addresses of your primary and standby nodes.   For local testing,
set `primary` and `standby` to 'localhost'.
Use `primary_db` and `standby_db` to specify the names of the directories that will hold the primary
and standby databases.
Finally, set `pg_test_bin` to `<INSTALL_DIR>/bin` to identify the PostgresSQL installation you want to test.

Instead of editing `vars.txt`, you can also provide the necessary configuration information by setting
the environment variables `PRIMARY`, `STANDBY`, `PRIMARY_DB`, `STANDBY_DB`, and `PG_TEST_BIN`.

## Running tests

Once configuration has been completed, run:
```
# On the primary node
./primary-reinit.sh 
```
and
```
# On the standby node
./standby-reinit.sh
```
The cluster is configured, by default, to use synchronous streaming replication with the 'serializable' isolation level
and `synchronous_commit=on`. To run tag transactions as 'fast' or to run async transactions in baseline PG, uncomment this line in `primary-reinit.sh':

```
#sed -i -e '/synchronous_commit =/ s/= .*/= off/' ${primary_db}/postgresql.conf
```

### Durability costs test
We perform a simple experiment intended to show the impact of durability on transaction latency in our setting.
For these experiments, we use a database with a single table containing two columns
(integer keys and values) and one million rows.
There is a single client which generates one transaction at a time, with no think time between successive transactions.
Each transaction updates a value in a single row, selected uniformly at random.   
We run the client for two minutes, and measure and report the mean transaction latency observed by the client. 

For this experiment, the `PRIMARY` node is in the same AZ as the test client, and the `STANDBY` is needed 
in the same AZ, a different AZ and a different region as the `PRIMARY`. Once the primary and standby have 
been initialised using the scripts `primary-reinit.sh` and `standby-reinit.sh`, run:
```
# On the primary
./create.sh 
```
Make sure the number of rows is set to 1M for this test. Once the table is populated, run:
```
# On the test-client
cd ed-tests/durability-costs && ./test.sh 
```
This records latency, TPS and other metrics from `pgbench`. Repeat the experiment when the `STANDBY` is in the same AZ,
different AZ and a different region as the `PRIMARY`.

### ED Transaction latencies
Our next experiment is intended to show the latency of fast and safe transactions in ED-Postgres. 
For this experiment, we use the same database as in the durability-costs experiments. 
Four concurrent `pgbench` clients each send one transaction at a time, with no think time between requests.
Two of the clients issue update transactions, each of which updates a single randomly selected row from the table.
One of the two update clients issues fast transactions, and the other issues safe transactions.
The two remaining clients issue read-only transactions, each of which reads a single randomly selected row from the table.
Again, one of the read-only clients issues fast read-only transactions, while the other issues safe ones.
Each experimental run lasts for 2 minutes, and we measure the mean client-side latency of each of the four types of transactions.

The steps to run these experiments are the same as the previous one:
```
# On the primary
./primary-reinit.sh

# On the standby
./standby-reinit.sh 
```
```
# On the primary
./create.sh 
```
```
# On the test client
cd ed-tests/ed-txn-tests && ./test.sh 
```

### Contention tests
We perform this experiment with high contention levels to show that ED Postgres has better throughput than baseline PG
since it releases resources earlier. After performing initialisations of the primary and standby node, update the `init.sql`
script on the primary to use:
```
insert into data values(generate_series(1, 250), generate_series(1, 250));
```
Instead of 1M row inserts. Then, on the test client, run:
```
cd ed-tests/contention && ./test.sh
```

Note that re-initialisations are necessary whenever the db flavour (ED/baseline) or transaction type (fast/safe) changes.

### TPC-C
To run TPC-C tests, we use a slightly modified version of [CMU's benchbase](https://github.com/cmu-db/benchbase) to support
fast and safe transactions. 
```
cd ed-tests/tpcc/benchbase
```
If you are running `NewOrder` as a fast transaction, then this additional step is necessary. 
```
vim src/main/java/com/oltpbenchmark/benchmarks/tpcc/TPCCWorker.java
```
Uncomment [these lines]([url](https://github.com/pct960/benchbase/blob/f453eb0fc525350178b99707b2f807f6775a2fe6/src/main/java/com/oltpbenchmark/benchmarks/tpcc/TPCCWorker.java#L70-L73)), so that the condition is now:
```
        if(tName.equalsIgnoreCase("NewOrder"))
            proc.run(fastConn, gen, terminalWarehouseID, numWarehouses,
              terminalDistrictLowerID, terminalDistrictUpperID, this);
        else
	    proc.run(safeConn, gen, terminalWarehouseID, numWarehouses,
            terminalDistrictLowerID, terminalDistrictUpperID, this);
```

If you're running all transaction types as safe, then do not make this change. Then, run:
```
./mvnw clean package -P postgres
cd target
tar xvzf benchbase-postgres.tgz
cd benchbase-postgres
```
Copy the config file from the tpcc directory:
```
cp ../../../data/all-safe/tpcc_2024-02-11_21-32-47.config.xml config/postgres/sample_tpcc_config.xml
```
On the primary, run:
```
create database benchbase
```
Run benchbase on the test client:
```
java -jar benchbase.jar -b tpcc -c config/postgres/sample_tpcc_config.xml --create=true --load=true --execute=true
```
