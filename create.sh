#!/bin/bash

# get configuration variables
source ./vars.sh

until ${pg_test_bin}/pg_isready
do
	echo "Waiting for standby ..."
	sleep 1
done

${pg_test_bin}/psql -U postgres -f init.sql
