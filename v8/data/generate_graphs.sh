#!/bin/bash

palette="#FF0000 #005500 #0000FF #000000"
summary_palette="#ff1a1a #4ebe2a #f96eec #26b1dd #fcb500"

# Reboot
subdir=results/001-20150808/1

target=reboot-rtt-normal-summary.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --maxtime 300 --maxrtt 500 --width 9 --height 5.96 --palette "$palette" --summary-palette "$summary_palette" --legend topright --summary-only $subdir < generic.R
mv $subdir/rtt-normal-summary.svg $subdir/$target

target=reboot-rtt-ecdf-zoom.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 140 --maxtime 200 --maxrtt 50 --width 6.4 --height 4 --palette "$palette" --summary-palette "$summary_palette" --summary-only $subdir < generic.R
mv $subdir/rtt-ecdf-summary.svg $subdir/$target

target=reboot-rtt-normal-zoom.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 140 --maxtime 200 --maxrtt 20 --width 6.4 --height 4 --palette "$palette" --summary-palette "$summary_palette" --legend topleft --summary-only $subdir < generic.R
mv $subdir/rtt-normal-summary.svg $subdir/$target

# Ping
subdir=results/001-20150808/2
target=ping-rtt-ecdf-zoom.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 0 --maxtime 300 --maxrtt 10 --width 6.4 --height 4 --palette "$palette" --summary-palette "$summary_palette" --summary-only $subdir < generic.R
mv $subdir/rtt-ecdf-summary.svg $subdir/$target

target=ping-rtt-normal.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 0 --maxtime 300 --maxrtt 300 --width 6.4 --height 4 --palette "$palette" --summary-palette "$summary_palette" --legend topleft --summary-only $subdir < generic.R
mv $subdir/rtt-normal-summary.svg $subdir/$target

target=ping-rtt-normal-babel.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 0 --maxtime 300 --maxrtt 10 --width 6.4 --height 4 --palette "#FF0000 #005500 #0000FF #000000" --summary-palette "#ff1a1a #4ebe2a #f96eec #26b1dd #fcb500"  results/001-20150808/2/Babel/ < generic.R
mv $subdir/Babel/Babel-4.svg $subdir/$target

# ping + iperf
subdir=results/001-20150808/3
target=pingiperf-rtt-ecdf-zoom.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 0 --maxtime 300 --maxrtt 100 --width 6.4 --height 4 --palette "$palette" --summary-palette "$summary_palette" --summary-only $subdir < generic.R
mv $subdir/rtt-ecdf-summary.svg $subdir/$target

target=pingiperf-rtt-normal.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 0 --maxtime 300 --maxrtt 300 --width 6.4 --height 4 --palette "$palette" --summary-palette "$summary_palette" --legend topright --summary-only $subdir < generic.R
mv $subdir/rtt-normal-summary.svg $subdir/$target

target=pingiperf-bitrate-normal.svg
echo -e "\033[34;1;4m** Drawing $target **\033[0m"
R --vanilla --slave --args --out-type svg --separate-output --mintime 0 --maxtime 300 --maxrtt 300 --width 6.4 --height 4 --palette "$palette" --summary-palette "$summary_palette" --summary-only $subdir < generic.R
mv $subdir/bitrate-normal-summary.svg $subdir/$target

