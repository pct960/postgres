#!/bin/bash
sudo pkill -9 postgres
rm -rf node-2
pg_basebackup -h 10.0.1.35 -U postgres -p 5432 -D node-2 -Fp -Xs -P -R
#sed -i '/#hot_standby/s/^#//g' node-2/postgresql.conf
#sed -i -e "/cluster_name =/ s/= .*/= \\'replica1\\'/" node-2/postgresql.conf
#sed -i -e "/default_transaction_isolation =/ s/= .*/= \\'read committed\\'/" node-2/postgresql.conf
cp postgresql.conf.replica1 node-2/postgresql.conf 
./start node-2

