#!/bin/bash

LOGFILE="~/ham/wspr/wspr10m.log"
CALLSIGN=
LOCATOR=

date >> $LOGFILE
#while true
#do
	rtlsdr_wsprd -f 10m -c $CALLSIGN -l $LOCATOR >> $LOGFILE 2>&1
#done

