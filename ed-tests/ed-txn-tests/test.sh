#!/bin/bash

env PGOPTIONS="-c synchronous_commit=on" pgbench -h 10.0.1.48 -U postgres postgres -p 5432 -f write.sql -T 120 -l -r --log-prefix=safe-write > safe-write.out &
env PGOPTIONS="-c synchronous_commit=on" pgbench -h 10.0.1.48 -U postgres postgres -p 5432 -f read.sql -T 120 -l -r --log-prefix=safe-read > safe-read.out &
env PGOPTIONS="-c synchronous_commit=off" pgbench -h 10.0.1.48 -U postgres postgres -p 5432 -f write.sql -T 120 -l -r --log-prefix=fast-write > fast-write.out &
env PGOPTIONS="-c synchronous_commit=off" pgbench -h 10.0.1.48 -U postgres postgres -p 5432 -f read.sql -T 120 -l -r --log-prefix=fast-read > fast-read.out &

