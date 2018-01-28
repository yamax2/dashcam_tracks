#!/bin/sh

gpsbabel -i nmea -f "1.nmea" -o gpx,gpxver=1.1 -F "outputfilename.gpx"
