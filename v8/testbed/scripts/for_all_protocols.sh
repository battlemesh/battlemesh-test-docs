#!/bin/bash

if [ "$#" != "1" ]
then
	echo "Error, one parameter required"
	echo "${0} <ping-packet-size>"
	exit 1
fi

echo "Test Babel"
./switch_all_routers.sh babeld
sleep 120
./run_test_4-5.sh babel ${1}

echo "Test Olsrd2"
./switch_all_routers.sh olsrd2
sleep 120
./run_test_4-5.sh olsrd2 ${1}

echo "Test Olsrd"
./switch_all_routers.sh olsrd
sleep 120
./run_test_4-5.sh olsrd ${1}

echo "Test Bmx6"
./switch_all_routers.sh bmx6
sleep 120
./run_test_4-5.sh bmx6 ${1}

echo "Test Batman-adv"
./switch_all_routers.sh batman-adv
sleep 120
./run_test_4-5.sh batman-adv ${1}
