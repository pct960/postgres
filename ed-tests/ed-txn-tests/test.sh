#!/bin/bash

# get configuration variables
source ../../vars.sh

test_runtime=10

#env PGOPTIONS="-c synchronous_commit=on" ${pg_test_bin}/pgbench -h $primary -U postgres postgres -p 5432 -f write.sql -T $test_runtime -l -r --log-prefix=safe-write > safe-write.out &
#env PGOPTIONS="-c synchronous_commit=on" ${pg_test_bin}/pgbench -h $primary -U postgres postgres -p 5432 -f read.sql -T $test_runtime -l -r --log-prefix=safe-read > safe-read.out &
env PGOPTIONS="-c synchronous_commit=off" ${pg_test_bin}/pgbench -h $primary -U postgres postgres -p 5432 -f write.sql -T $test_runtime -l -r --log-prefix=fast-write > fast-write.out &
#env PGOPTIONS="-c synchronous_commit=off" ${pg_test_bin}/pgbench -h $primary -U postgres postgres -p 5432 -f read.sql -T $test_runtime -l -r --log-prefix=fast-read > fast-read.out &
