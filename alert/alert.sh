#!/bin/bash

# A script for automated sound alerts. 
# Usage: 
# ./alert.sh once file.mp3
#   - play file.mp3 ONCE
# ./alert.sh repeat file.mp3
#   - play file.mp3 FOREVER
# ./alert.sh stop
#   - stop all repeating tracks.
#   WARNING: this kills all mplayer processes!

if [ $# -ne 2 ] && [ "$1" != "stop" ] ; then
    echo "Usage: $0 <stop|once|repeat> [filename]" 
    exit 1
fi

mode=$1
filename=$2

if [ "$mode" == "stop" ] ; then
    killall mplayer
    exit 0
fi

if [ ! -e "$filename" ] ; then
    echo "Audio file does not exist."
    exit 1
fi

if [ "$mode" == "repeat" ]; then
    mplayer -loop 0 "$filename" < /dev/null > /dev/null 2>&1 &
    disown $!
elif [ "$mode" ==  "once" ]; then
    mplayer "$filename" < /dev/null > /dev/null 2>&1 &
    disown $!
else
    echo "Invalid mode."
    exit 1
fi
