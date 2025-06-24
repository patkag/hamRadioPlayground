#!/bin/bash

IP="192.168.1.1"
LogFile="~/myLogs/pRlog.txt"
COUNT=3
doUntil=true
 while $doUntil; do
  sleep 600

  ping -c $COUNT $IP > /dev/null
  # Check the exit status of the ping command
  if [ $? -ne 0 ]; then
    echo "Ping failed. Rebooting the system..." >> $LogFile
    date >> $LogFile
    doUntil=false
    reboot
  fi
 done
