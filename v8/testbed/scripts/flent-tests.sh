#!/bin/sh
N="flent -4 -x -l 60 --disable-log"
#S=2001:4f8:3:203::c001 # netperf-west.bufferbloat.net # netperf-west, netperf-eus
S=10.0.1.2
if [ $# -ne 2 ]
then
echo must specify a title and subdirectory
exit -1
else
title="$1"
fi

cd $2

ping -c 2 $S # prime the dns cache

$N -H $S -t "$title" rrul
$N -H $S -t "$title" rrul_be
$N -H $S -t "$title" dslreports_8dn

$N -H $S -t "$title" tcp_upload
$N -H $S -t "$title" tcp_download
