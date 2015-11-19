#!/bin/bash

exec 1> >(/usr/bin/logger -s -t $(basename $0)) 2>&1

/sbin/modinfo ixgbe
/sbin/rmmod ixgbe
echo "unload the current ixgbe driver"
/sbin/insmod /lib/modules/4.1.13-gzhang-fastly/updates/drivers/net/ethernet/intel/ixgbe/ixgbe.ko
echo "load the ixgbe driver from updates"
