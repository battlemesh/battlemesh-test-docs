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
IPERF_CLIENT="-u -i 0.5 -t 300 -yC -b 10M"
IPERF_SERVER="-u"

# Files to write test-data into
TESTPATH="./battlemesh_test_${PROTOCOL}/${DATE}"

mkdir -p ${TESTPATH}/1
mkdir -p ${TESTPATH}/2
mkdir -p ${TESTPATH}/3
mkdir -p ${TESTPATH}/4

LOGFILE="${TESTPATH}/log"
TEST1="${TESTPATH}/1"
TEST2="${TESTPATH}/2"
TEST3="${TESTPATH}/3"
TEST4="${TESTPATH}/4"

# prepare
ssh ${SSH_SERVER} "pkill iperf; iperf -s ${IPERF_SERVER} >/dev/null" &
rm -f ${LOGFILE}

# test 1
echo "Test 1 (reboot+ping) starting at $(date)"

echo "Test 1 start: $(date +%s)" >> ${LOGFILE}
ping ${PING} ${SERVER} > ${TEST1}/ping &
sleep 60

ssh root@172.17.0.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.8.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.16.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.24.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.32.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.40.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.48.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.56.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.64.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"
ssh root@172.17.72.1 "reboot -d 30 >/dev/null </dev/null 2>/dev/null &"

sleep 240

echo "Test 1 stop: $(date +%s)" >> ${LOGFILE}

echo "Test 1 finished"
sleep 60

# test 2
echo "Test 2 (ping) starting at $(date)"

echo "Test 2 start: $(date +%s)" >> ${LOGFILE}
ping ${PING} ${SERVER} > ${TEST2}/ping
echo "Test 2 stop: $(date +%s)" >> ${LOGFILE}

echo "Test 2 finished"
sleep 60

# test 3
echo "Test 3 (ping+iperf) starting at $(date)"

echo "Test 3 start: $(date +%s)" >> ${LOGFILE}
$(iperf -c ${SERVER} ${IPERF_CLIENT} > ${TEST3}/iperf) &
ping ${PING} ${SERVER} > ${TEST3}/ping
echo "Test 3 stop: $(date +%s)" >> ${LOGFILE}

echo "Test 3 finished"
sleep 60

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

ssh ${SSH_SERVER} "pkill iperf"
killall ssh

