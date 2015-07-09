#!/bin/bash

if [ "$1" = "" ] ; then
        echo "Description:"
        echo "    This script attempts to calculate per-core interrupts for a multi-queue NIC based on two snapshots of /proc/interrupts"
        echo "usage:"
        echo "    $0 /proc/interrupts1 /proc/interrupts2 p5p2"
fi

NIC=$3
NIC+="-"
FILENAME1=$1
HOSTNAME1=(`echo $FILENAME1 | awk -F'_' '{print $1}'`)
CORES1=(`echo $FILENAME1 | awk -F'_' '{print $2}'`)
TIMESTAMP1=(`echo $FILENAME1 | awk -F'_' '{print $3}'`)

#echo $HOSTNAME1
#echo $CORES1
#echo $TIMESTAMP1

FILENAME2=$2
HOSTNAME2=(`echo $FILENAME2 | awk -F'_' '{print $1}'`)
CORES2=(`echo $FILENAME2 | awk -F'_' '{print $2}'`)
TIMESTAMP2=(`echo $FILENAME2 | awk -F'_' '{print $3}'`)

#echo $HOSTNAME2
#echo $CORES2
#echo $TIMESTAMP2

if [ "$HOSTNAME1" != "$HOSTNAME2" ]; then
	echo "Error: the snapshots are from different hosts"
	exit
fi
	
if [ "$TIMESTAMP2" -gt "$TIMESTAMP1" ]; then
	#echo "$2 is newer than $1"
	START=$1
	END=$2
else
	#echo "$1 is newer than $2"
	START=$2
	END=$1
fi

for core in `seq 2 41`;
do
	grep $NIC $START | awk '{ SUM += $col } END { print SUM }' col=$core >> __start
	grep $NIC $END | awk '{ SUM += $col } END { print SUM }' col=$core >> __end
done

echo before comment
: <<'END'

if [ "$CORES1" -le 40 ]; then
	grep $NIC $START | awk \
	'{print \
	$2+$3+$4+$5+$6+$7+$8+$9+\
	$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+\
	$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+\
	$30+$31+$32+$33+$34+$35+$36+$37+$38+$39+\
	$40+$41\
	}' > __start

	grep $NIC $END | awk \
	'{print \
	$2+$3+$4+$5+$6+$7+$8+$9+\
	$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+\
	$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+\
	$30+$31+$32+$33+$34+$35+$36+$37+$38+$39+\
	$40+$41\
	}' > __end
else
	echo "the cores is not 40"
	exit
fi
END
echo after comment

paste __start __end | awk '{ print $2 - $1 }' > ttt

nl -v 0 -nln ttt > $3.txt
rm ttt
rm __end
rm __start

gnuplot -e "datafile='$3.txt'" bar_$CORES1.gnuplot
mv bar.png $HOSTNAME1.$3.png
rm $3.txt
