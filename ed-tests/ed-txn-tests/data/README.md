# Setup
1. 1 primary c5.4xlarge in us-east-1a, 1 standby m5.large. Started w/o standby, then standby in us-east-1b and then in ca-central-1
2. 4 pgbench processes: Each uses 1 client, 1 thread, no retries, no rate. Ran for 120s. Each txn updates 1 row in table containing 1M key and value ints
3. Carried out on both baseline and ED Postgres
