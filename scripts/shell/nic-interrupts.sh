#!/bin/bash

if [ "$1" = "" ] ; then
	echo "Description:"
	echo "    This script attempts to calculate per-core interrupts for a multi-queue NIC"
	echo "usage:"
	echo "    $0 p5p2- /proc/interrupts"
fi

grep $1 $2 | awk \
'{print \
$2+$3+$4+$5+$6+$7+$8+$9+\
$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+\
$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+\
$30+$31+$32+$33+$34+$35+$36+$37+$38+$39+\
$40+$41\
}' > ttt.txt

nl -v 0 -nln ttt.txt > $1.txt
rm ttt.txt

#vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
