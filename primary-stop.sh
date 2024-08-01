#!/bin/bash

# get configuration vars
source ./vars.sh

${pg_test_bin}/pg_ctl -D ${primary_db} stop
