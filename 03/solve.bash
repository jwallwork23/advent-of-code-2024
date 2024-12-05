#!/bin/bash

# Load test data if arguments are passed, otherwise main data
if [ "$1" == "" ]; then
  FILE1=main.dat
  FILE2=main.dat
else
  FILE1=test1.dat
  FILE2=test2.dat
fi

# Strip out all the calls to mul on separate lines and convert mul(.,.) to (.*.)
grep -roE "mul\([0-9]+,[0-9]+\)" ${FILE1} | sed "s/mul//" | sed "s/,/*/" >muls.dat

# Sum over each multiplication
PART1=0
IFS=$'\n' # Set Internal Field Separator to split on newlines
for LINE in $(cat muls.dat); do
  PART1=$(bc -l <<<"${PART1} + ${LINE}")
done
echo "PART1: ${PART1}"

# Strip out all the calls to mul on separate lines and convert mul(.,.) to (.*.)
# and "do()" to "do" to avoid Bash misinterpreting it as a function
grep -roE -e "mul\([0-9]+,[0-9]+\)" -e "do\(\)" -e "don't\(\)" \
  ${FILE2} | sed "s/mul//" | sed "s/,/*/" | sed "s/do()/do/" >all.dat

# Sum over enabled multiplications
PART2=0
okay=true
for LINE in $(cat all.dat); do
  if [ "${LINE}" == "do" ]; then
    okay=true
  elif [ "${LINE}" == "don't()" ]; then
    okay=false
  fi
  if [ "${okay}" == true ]; then
    PART2=$(bc -l <<<"${PART2} + ${LINE}")
  fi
done
echo "PART2: ${PART2}"
