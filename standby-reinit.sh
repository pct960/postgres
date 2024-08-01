#!/bin/bash

# get configuration variables
source ./vars.sh

echo "standby: $standby_db at ${standby}/5433"

/bin/rm -rf ${standby_db}
echo "establishing initial backup"
${pg_test_bin}/pg_basebackup -h ${primary} -U postgres -p 5432 -D ${standby_db} -Fp -Xs -P -R
echo "configuring standby server"
cp postgresql.conf.replica1 ${standby_db}/postgresql.conf
#sed -i '/#hot_standby/s/^#//g' ${standby_db}/postgresql.conf
#sed -i -e "/cluster_name =/ s/= .*/= \\'replica1\\'/" ${standby_db}/postgresql.conf
#sed -i -e "/default_transaction_isolation =/ s/= .*/= \\'read committed\\'/" ${standby_db}/postgresql.conf
#sed -i '/#port =/ s/#port = .*/port = 5433/' ${standby_db}/postgresql.conf
echo "launching standby server"
${pg_test_bin}/pg_ctl -D ${standby_db} start
