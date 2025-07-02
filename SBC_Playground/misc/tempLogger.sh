#!/bin/bash

logFile="~/myLogs/tempLog.log"

while true; do
  date >> $logFile
  cat /sys/class/thermal/thermal_zone0/temp >> $logFile
  sleep 300
done
