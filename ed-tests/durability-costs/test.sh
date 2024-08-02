#!/bin/bash

# get configuration variables
source ../../vars.sh

test_runtime=10

# Basic latency tests
${pg_test_bin}/pgbench -h $primary -U postgres postgres -p 5432 -c 1 -j 1 -f write.sql -T $test_runtime -r -l
