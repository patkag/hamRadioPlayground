#!/bin/bash

# Configuration
#TLE_FILE="iss.tle"
FREQUENCY=145800000  # Frequency in Hz (145.8 MHz for ISS)
DURATION=600  # Duration in seconds
END_TIME=$(date -d "+17 hours" +%s)  # End time one week from now


WORKDIR=~/ham/sdr/iss

PREDICTIONS_FILE=$WORKDIR"/passes.txt"

echo "Script is started at $(date)" >> $WORKDIR/log.txt
echo "WORKDIR: $WORKDIR/something" >> $WORKDIR/log.txt


# Download the latest TLE data for the ISS
#curl -o $TLE_FILE https://www.celestrak.com/NORAD/elements/stations.txt

while [ $(date +%s) -lt $END_TIME ]; do
    # Get current time in Unix timestamp
    CURRENT_TIME=$(date +%s)

    # Get the next pass time
    NEXT_PASS=$(predict -p 25544 | head -n 1 | awk '{print $1}')

    predict -p 25544 >> $PREDICTIONS_FILE
    printf "\n\n###########################\n\n" >> $PREDICTIONS_FILE

    # Wait until the ISS is above
    while [ $CURRENT_TIME -lt $NEXT_PASS ]; do
        sleep 10
        CURRENT_TIME=$(date +%s)
    done

    # Generate a timestamp for the file name
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    # Define the output file with the timestamp
    OUTPUT_FILE="$WORKDIR/rec/iss_recording_$TIMESTAMP.wav"

    # Start recording 
timeout -s SIGTERM $DURATION rtl_fm -f $FREQUENCY -s 22050 -M fm -g 25.4 -E deemp -F 9 -o 4 - | sox -t raw -r 22050 -e signed -b 16 -c 1 -V1 - $OUTPUT_FILE rate 48k

    echo "Recording saved to $OUTPUT_FILE" >>$WORKDIR/log.txt

    # Sleep for the duration of the recording to avoid overlapping
    sleep $DURATION
done

echo "Script has finished running, time: $(date)" >> $WORKDIR/log.txt



