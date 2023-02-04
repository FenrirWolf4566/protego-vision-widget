#!/bin/bash

# When you work on your computer all day, you should take breaks to protect your eyes and give them a rest.
# This little widget informs you of the time elapsed since the last time you logged in and and flashes red 
# to warn you to take a break depending on the time (in minutes set)

# Example usage: 
# $ bash time.sh    -> default 20 minutes
# $ bash time.sh 40 -> 40 minutes

# Set time (in minutes) that you want to be noticed (default is 20 minutes)
if [ $# -eq 1 ]
then
  SET_TIME="$1"
else
  SET_TIME=20
fi

#echo $SET_TIME
# Convert min to sec
SET_TIME=$(( $SET_TIME * 60 ))

# Log since last sleep
LOG=$(journalctl -n1 -u sleep.target)
# Time since last sleep
TIME_SINCE_SLEEP=$(echo $LOG | awk '{print $3}')
# Current time on your device
TIME=$(date +%H:%M:%S)
# Difference between TIME_SINCE_SLEEP and TIME
DELTA_SECOND=$(( $(date -d "$TIME" "+%s") - $(date -d "$TIME_SINCE_SLEEP" "+%s") ))
# Convert to %H:%M:%S format
DELTA_DATE=$(date -d@"$DELTA_SECOND" -u +%H:%M:%S)
#CURRENT_TIME=$(echo $DELTA_DATE | awk '{print $5}')

# Red flash
if [ "$DELTA_SECOND" -gt "$SET_TIME" ]
then
  ## Flashing Red
  if [ $(($DELTA_SECOND % 2)) == 0 ]
  then
    $INFO="<txt><span weight='Bold' fgcolor='Red'>   $DELTA_DATE   </span></txt>"
  else
    echo "   $DELTA_DATE   "
  fi
else
  echo "   $DELTA_DATE  "
fi
