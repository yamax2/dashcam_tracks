#!/bin/sh
ffmpeg -f concat -i mylist.txt -map 0:s:0 -c copy -f data out.data