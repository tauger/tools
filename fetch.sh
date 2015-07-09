#!/bin/bash

if [ "$1" = "" ] ; then
        echo "Description:"
        echo "    This script attempts to fetch /proc/interrupts from a remote host"
        echo "usage:"
        echo "    $0 hostname interval"
	exit
fi

HOSTNAME=$1
SLEEP=$2
./fetch_int_count.sh $HOSTNAME
sleep $SLEEP
./fetch_int_count.sh $HOSTNAME
