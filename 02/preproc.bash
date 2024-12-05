#!/usr/bin/bash

sed -e "s/^/ /" main.dat >proc.dat
sed -i "s/$/ /" proc.dat
# sed -i "s/ [0-9]\{1\} / 0& /g" proc.dat  # FIXME
for i in {0..9}; do
  sed -i "s/ $i / 0$i /g" proc.dat
done
