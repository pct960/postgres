#!/bin/bash

#################################################
# CONFIGURATION DEFAULTS
# ###############################################
# IP addresses of primary and standby servers
# use "localhost" for local testing
primary=localhost
standby=localhost

# database directories
primary_db="./primary-node"
standby_db="./standby-node"

# PostgreSQL bin - location of PG install to be tested
pg_test_bin="${HOME}/shared/postgres-ed-pgsql/bin"

##################################################
# END CONFIGURATION DEFAULTS
##################################################

##################################################
# override defaults with environment variables, if set
##################################################
if [[ -v PRIMARY ]]; then
    primary=${PRIMARY}
fi
if [[ -v STANDBY ]]; then
    standby=${STANDBY}
fi
if [[ -v PRIMARY_DB ]]; then
    primary_db=${PRIMARY_DB}
fi
if [[ -v STANDBY_DB ]]; then
    standby_db=${STANDBY_DB}
fi
if [[ -v PG_TEST_BIN ]]; then
    pg_test_bin=${PG_TEST_BIN}
fi







#PRIMARY=""
#STANDBY=""

# TELEGRAM VARS
TOKEN=""
ID=""
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
