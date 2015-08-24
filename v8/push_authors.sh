#!/bin/bash -e

for f in $(ls *.rst); do
    old=$(awk '
/^Article written by/ {x = $0}
END { if (x) {print x} else {print "none"}}' $f)

    authors=$(git log --follow --pretty=format:%an "$f" |
        sort -u |
        awk '
BEGIN { printf("Article written by ") }
NR != 1 {printf(", ")}
{printf("%s", $0)}
END {print ".\n"}')

    if [ "$old" == "none" ]; then
        echo "$f"
        echo "    new = $authors"
        echo >> "$f"
        echo "$authors" >> "$f"
    elif [ "$old" != "$authors" ]; then
        echo "$f"
        echo "    old = $old"
        echo "    new = $authors"
        printf %s\\n d w q | ed -s $f  # remove last line of the file
        echo "$authors" >> "$f"
    fi

done

cat <<EOF
**Warning**
  Please, commit the results of each file only with the name of one of the
  actual authors of the file.  Otherwise, your name may be added without reason.
EOF
