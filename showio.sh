#!/bin/bash

#THRESHOLD=40
#MAX_THRESHOLD=100
INFOS="`iostat -x 1 2  | grep -A 3 util  | tail -n 3 | awk '{print $1" "$14}' | awk -F '.' '{print $1}' | sort`"

UTIL_A=`echo "$INFOS" | grep 'sda' | awk '{print $2}'`
#test $UTIL_A -ge $MAX_THRESHOLD && UTIL_A=MAX
#test "$UTIL_A" != "MAX" && UTIL_A=$UTIL_A%

UTIL_B=`echo "$INFOS" | grep 'sdb' | awk '{print $2}'`
#test $UTIL_B -ge $MAX_THRESHOLD && UTIL_B=MAX
#test "$UTIL_B" != "MAX" && UTIL_B=$UTIL_B%

UTIL_C=`echo "$INFOS" | grep 'sdc' | awk '{print $2}'`
#test $UTIL_C -ge $MAX_THRESHOLD && UTIL_C=MAX
#test "$UTIL_C" != "MAX" && UTIL_C=$UTIL_C%

#printf "/home:%2d%%, /nobackup:%2d%%, /:%2d%%" $UTIL_B $UTIL_C $UTIL_A
printf "/home:%2d%%, /nobackup:%2d%%" $UTIL_B $UTIL_C
