#!/bin/sh

gpsbabel -i nmea -f "2.txt" -o gpx,gpxver=1.1 -F "outputfilename.gpx"
