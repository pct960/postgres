#!/bin/bash
until pg_isready
do
	echo "Waiting for standby ..."
	sleep 1
done

psql -U postgres -f init.sql

