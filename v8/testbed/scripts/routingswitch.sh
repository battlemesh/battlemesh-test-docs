#!/bin/bash
if [ "$#" != "2" ]
then
        echo "Error, two parameters required"
        echo "${0} <router-ip> <bmx6|olsrd|olsrd2|babeld|batman-adv>"
        exit 1
fi

IP="${1}"
PROTO="${2}"
SSH="ssh root@${IP}"

SSH_CMD="/etc/init.d/bmx6 disable ; /etc/init.d/olsrd disable ; /etc/init.d/olsrd2 disable ; /etc/init.d/olsrd6 disable ; /etc/init.d/babeld disable"

if [ "${PROTO}" == "batman-adv" ]; then
	SSH_CMD="${SSH_CMD} ; cp /etc/config/network.batman-adv /etc/config/network"
elif [ "${PROTO}" == "olsrd" ]; then
	SSH_CMD="${SSH_CMD} ; /etc/init.d/olsrd enable ; /etc/init.d/olsrd6 enable ; cp /etc/config/network.all /etc/config/network"
else
	SSH_CMD="${SSH_CMD} ; /etc/init.d/${PROTO} enable ; cp /etc/config/network.all /etc/config/network"
fi

${SSH} "${SSH_CMD}"

exit 0
