#!/bin/bash

# get configuration variables
source ../../vars.sh

# Basic latency tests
${pg_test_bin}/pgbench -h $primary -U postgres postgres -p 5432 -c 1 -j 1 -f write.sql -T 10 -r -l
