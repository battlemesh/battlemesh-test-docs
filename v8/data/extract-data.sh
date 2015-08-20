#!/bin/bash -e

# Copyright (c) 2015 by Matthieu Boutier

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

usage() {
    echo "usage: $0 [input <file|dir>] [all]"
    exit 0
}

skip=true
input=

arg=1
while [ $arg -le $# ]; do
    case ${!arg} in
        a*) skip=false;; # all
        i*) arg=$(($arg + 1)); input=${!arg};;
        help|*) usage;;
    esac
    arg=$(($arg + 1))
done

if [ -z $input ]; then
    input="."
fi


extract_ping() {
    in="$1"
    out="$2"
    if $skip && [ -f $out.csv ]; then
        echo "[skip]" $in "->" $out.csv
        return
    fi
    echo "[make]" $in "->" $out.csv
    echo "timestamp rtt ttl seq" > $out.csv
    awk -F '[ =[]|]' '
/Unreachable/ {print $2" NA NA NA"; next}
/^\[/{print $2" " $13" " $11" "$9}' "$in" >> $out.csv
}

for f in $(find "$input" -name "*ping"); do
    out="$f"
    extract_ping "$f" "$out"
done

exit 0
