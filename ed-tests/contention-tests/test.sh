#!/bin/bash

# get configuration variables
source ../../vars.sh

test_name="contention-tests-128-clients"

# Change to 0.5 for low contention, and 0.95 for 
# high contention
config=0.95

# Change to "baseline" or "ed" depending on
# the flavour of PG being used for the test
db_flavour="baseline"

# Change description depending on the contention level
test_type="high-contention"
rates=$(seq 2000 2000 50000)

# Change type to "fast" or "safe" depending on the 
# type of txn used
txn_type="fast"

clients=128
threads=16
duration=10

for rate in ${rates[@]};
do
#	SECONDS=0
    	echo -e "\n\n=================================================Running $test_type/$db_flavour/$txn_type/$rate======================================================\n\n"
    	op_dir="output-logs/paper-exps/$test_name/$test_type/$db_flavour/$txn_type/$rate"
    	mkdir -p $op_dir
#    	ssh -t ubuntu@$PRIMARY 'cd postgres && ./primary-reinit.sh'
#    	ssh -t ubuntu@$STANDBY 'cd postgres && ./standby-reinit.sh'
#    	ssh -t ubuntu@$PRIMARY 'cd postgres && ./create.sh'
    	pgbench -h $primary -U postgres postgres -p 5432 -c $clients -j $threads -f update.sql -R $rate -T $duration -D split=$config --max-tries=5 --failures-detailed > $op_dir/out.txt
    	#mv pgbench_log* $op_dir/
#    	curl -s -X POST $URL -d chat_id=$ID -d text="Completed $txn_type/$config/$rate: Took $SECONDS"
done

# curl -s -X POST $URL -d chat_id=$ID -d text="All tests done"
