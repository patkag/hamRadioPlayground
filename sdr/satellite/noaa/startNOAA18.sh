#!/bin/bash

# Configuration
TLE_FILE="noaa.tle"
FREQUENCY=137912500  # Frequency in Hz (137.9125 MHz for NOAA 18)
#FREQUENCY=137100000 #NOAA19
#FREQUENCY=137520000 #NOAA15

DURATION=900  # Duration in seconds
END_TIME=$(date -d "+7 days" +%s)  # End time one week from now

# Download the latest TLE data for NOAA 18
#curl -o $TLE_FILE https://celestrak.org/NORAD/elements/weather.txt

#while [ $(date +%s) -lt $END_TIME ]; do
    # Get current time in Unix timestamp
    CURRENT_TIME=$(date +%s)

    # Get the next pass time
    NEXT_PASS=$(predict -p NOAA-18 | head -n 1 | awk '{print $1}')

    # Wait until the satellite is above
    while [ $CURRENT_TIME -lt $NEXT_PASS ]; do
        sleep 10
        CURRENT_TIME=$(date +%s)
    done

    # Generate a timestamp for the file name
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    # Define the output file with the timestamp
    OUTPUT_FILE="rec/noaa18_recording_$TIMESTAMP.wav"

    # Start recording
#    timeout -s SIGTERM $DURATION rtl_fm -f $FREQUENCY -s 40k -g 50 - | sox -t raw -r 22050 -e signed -b 16 -c 1 - $OUTPUT_FILE rate 48k

timeout -s SIGTERM $DURATION rtl_fm -M fm -f $FREQUENCY -s 40k -l 0 -E deemp -F 9 -o 4 | sox -r 40k -t raw -e s -b 16 -c 1 -V1 - $OUTPUT_FILE rate 48k

    echo "Recording saved to $OUTPUT_FILE"

    # Sleep for the duration of the recording to avoid overlapping
#    sleep $DURATION
#done

echo "Script finished"

