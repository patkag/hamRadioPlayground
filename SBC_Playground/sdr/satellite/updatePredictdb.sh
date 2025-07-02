#!/bin/sh
wget -qr https://www.amsat.org/tle/current/nasabare.txt -O amateur.txt
wget -qr https://celestrak.org/NORAD/elements/visual.txt -O visual.txt
wget -qr https://celestrak.org/NORAD/elements/weather.txt -O weather.txt
/usr/bin/predict -u amateur.txt visual.txt weather.txt
