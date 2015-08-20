#!/bin/bash
if [ "$#" != "2" ]
then
	echo "Error, two parameters required"
	echo "${0} <protocol-name> <ping-packet-size>"
	exit 1
fi

# get current time and used protocol
DATE="$(date +%s)"
PROTOCOL="${1}"

# IP addresses to communicate with
SERVER="10.0.1.2"
CROSS_CLIENT="172.17.24.1"
CROSS_SERVER="172.17.56.1"

# SSH access to defined IP addresses
SSH_SERVER="testclient@${SERVER}"
SSH_CROSS_CLIENT="root@${CROSS_CLIENT}"
SSH_CROSS_SERVER="root@${CROSS_SERVER}"

# Parameters for testing 
PING="-c 1500 -i 0.2 -D -s ${2}"
IPERF_CLIENT="-u -i 0.5 -t 300 -yC -b 100M"
IPERF_SERVER="-u"

# Files to write test-data into
TESTPATH="./battlemesh_test_${PROTOCOL}/${DATE}"

mkdir -p ${TESTPATH}/4
mkdir -p ${TESTPATH}/5

LOGFILE="${TESTPATH}/log"
TEST4="${TESTPATH}/4"
TEST5="${TESTPATH}/5"

# prepare
ssh ${SSH_SERVER} "pkill iperf; iperf -s ${IPERF_SERVER} >/dev/null" &
ssh ${SSH_SERVER} "pkill netserver; netserver >/dev/null" &
rm -f ${LOGFILE}

# test 4
echo "Test 4 (ping+iperf+iperf) starting at $(date)"
ssh ${SSH_CROSS_SERVER} "pkill iperf; iperf -s ${IPERF_SERVER} >/dev/null" &
ssh ${SSH_CROSS_CLIENT} "pkill iperf; iperf -c ${CROSS_SERVER} ${IPERF_CLIENT} >/dev/null" &

echo "Test 4 start: $(date +%s)" >> ${LOGFILE}
iperf -c ${SERVER} ${IPERF_CLIENT} > ${TEST4}/iperf &
ping ${PING} ${SERVER} > ${TEST4}/ping
echo "Test 4 stop: $(date +%s)" >> ${LOGFILE}

sleep 10
ssh ${SSH_CROSS_SERVER} "pkill iperf"
ssh ${SSH_CROSS_CLIENT} "pkill iperf"

echo "Test 4 finished"

# test 5
echo "Test 5 (ping+iperf) starting at $(date)"

echo "Test 5 start: $(date +%s)" >> ${LOGFILE}
./flent-tests.sh ${PROTOCOL} ${TEST5}/
echo "Test 5 stop: $(date +%s)" >> ${LOGFILE}

echo "Test 5 finished"
sleep 60

ssh ${SSH_SERVER} "pkill iperf"
ssh ${SSH_SERVER} "pkill netserver"
killall ssh
