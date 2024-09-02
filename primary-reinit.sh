#!/bin/bash

sudo pkill -9 postgres
rm -rf node-1
./init node-1
cp postgresql.conf.master node-1/postgresql.conf
cp pg_hba.conf node-1/
#sed -i '/synchronous_standby_names/s/^/#/g' node-1/postgresql.conf
#sed -i -e '/synchronous_commit =/ s/= .*/= off/' node-1/postgresql.conf
./start node-1
createuser -s postgres
./create.sh
sed -i '' '/^#synchronous_standby_names/s/^#//' node-1/postgresql.conf
./restart node-1

