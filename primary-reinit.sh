#!/bin/bash

# get configuration variables
source ./vars.sh

echo "primary: $primary_db at ${primary}/5432"

echo "initializing primary database"
/bin/rm -rf $primary_db
${pg_test_bin}/initdb -D ${primary_db} -E UNICODE --locale=C
echo "configuring primary server"
cp postgresql.conf.master ${primary_db}/postgresql.conf
cp pg_hba.conf ${primary_db}/
sed -i '/synchronous_standby_names/s/^/#/g' ${primary_db}/postgresql.conf
sed -i "/listen_addresses =/ s/= .*/= ${primary}/" ${primary_db}/postgresql.conf
# uncomment this to make asynchronous commit the default
#sed -i -e '/synchronous_commit =/ s/= .*/= off/' ${primary_db}/postgresql.conf
echo "launching primary server"
${pg_test_bin}/pg_ctl -D $primary_db start
echo "creating test database"
${pg_test_bin}/createuser -s postgres
./create.sh
sed -i '/synchronous_standby_names/s/^#//g' ${primary_db}/postgresql.conf
${pg_test_bin}/pg_ctl -D ${primary_db} restart
