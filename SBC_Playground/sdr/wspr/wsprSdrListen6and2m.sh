#!/bin/bash

LogFile="~/ham/wspr/rtlsdr_wsprd_script_log.txt"
CALLSIGN=
LOCATOR=
Duration=1800

while true; do
    timeout -s SIGTERM $Duration rtlsdr_wsprd -f 6m -c $CALLSIGN -l $LOCATOR >> $LogFile
    timeout -s SIGTERM $Duration rtlsdr_wsprd -f 2m -c $CALLSIGN -l $LOCATOR >> $LogFile

done


