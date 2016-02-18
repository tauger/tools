#!/bin/bash

VCL=$1
total=0

for m in `seq 0 128`;
do
	count=`grep "/$m;" $VCL |wc -l`
	let "total += $count"
	if [ "$count" != "0" ]
	then
		echo "mask $m: $count"
	fi
done
echo "total: $total"

