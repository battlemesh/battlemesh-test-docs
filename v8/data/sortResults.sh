#!/bin/sh

# Copyright (c) 2015 by Thijs van Veen <dicht@operamail.com>

#expecting files in the following 2 formats
# 1: sub-test data
# [prefix]_[protocol]_[time]_[test].[subtest]
# battlemesh_test_babel_1438972423_1.ping
#
# 2: sub-test timing
# [prefix]_[protocol]_[time]_log
# battlemesh_test_babel_1438973171_log

if [ $# -eq "1" ]; then
	cd "$1"
	pwd
fi


if [ ! -d time ]; then
	mkdir time	
fi
mv 2>/dev/null *_log time


for test in 1 2 3 4; do
	echo $test

	if [ ! -d "test_$test" ]; then
		mkdir "test_$test"
	fi
	mv 2>/dev/null *_${test}.* "test_$test"
done

exit 0

for file in $(ls); do
	#strip away the _test.... stuff for base name
	base=$(echo "${file}" | sed -n 's|\(.*\)\(_[[:digit:]]\)\..*$|\1|p')

	mkdir "${base}"
	mv *${base}* ${base}
done

