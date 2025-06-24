#!/bin/bash

LOGFILE="~/ham/wspr/wspr6m.log"
CALLSIGN=
LOCATOR=

date >> $LOGFILE
while true 
do
	rtlsdr_wsprd -f 6m -c $CALLSIGN -l $LOCATOR >> $LOGFILE
done

