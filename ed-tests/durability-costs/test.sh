#!/bin/bash

# Basic latency tests
pgbench -h $PRIMARY -U postgres postgres -p 5432 -c 1 -j 1 -f write.sql -T 120 -r -l






