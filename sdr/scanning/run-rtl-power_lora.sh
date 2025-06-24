#!/bin/bash

START_FRQ=869M
STOP_FRQ=870M
STEP=5k

OUT_FILE_NAME="lora_meshtastic_$(date +%Y%m%d_%H%M%S).csv"

rtl_power -f $START_FRQ:$STOP_FRQ:$STEP $OUT_FILE_NAME


