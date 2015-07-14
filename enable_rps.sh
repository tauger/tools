#!/bin/bash

NIC=$1

for i in `seq 0 31`; do echo ffffffff >  /sys/class/net/$NIC/queues/rx-$i/rps_cpus; done
