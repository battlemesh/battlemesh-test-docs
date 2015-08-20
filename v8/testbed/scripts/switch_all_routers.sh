#!/bin/bash

if [ "$#" != "1" ]
then
        echo "Error, one parameter required"
        echo "${0} <bmx6|olsrd|olsrd2|babeld|batman-adv>"
        exit 1
fi

PROTO="${1}"

./routingswitch.sh 172.17.0.1 ${PROTO}
./routingswitch.sh 172.17.8.1 ${PROTO}
./routingswitch.sh 172.17.16.1 ${PROTO}
./routingswitch.sh 172.17.24.1 ${PROTO}
./routingswitch.sh 172.17.32.1 ${PROTO}
./routingswitch.sh 172.17.40.1 ${PROTO}
./routingswitch.sh 172.17.48.1 ${PROTO}
./routingswitch.sh 172.17.56.1 ${PROTO}
./routingswitch.sh 172.17.64.1 ${PROTO}
./routingswitch.sh 172.17.72.1 ${PROTO}

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
