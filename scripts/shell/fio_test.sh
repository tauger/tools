#!/bin/bash

RESULTS='/root/fio_result'
FIO='/usr/bin/fio'
devices=sde
size=1024 

for dev in sde
do
  echo "fio testing on $dev"
  echo 4 > /sys/block/${dev}/queue/nr_requests
  echo 0 > /sys/block/${dev}/queue/read_ahead_kb
  echo 1 > /sys/block/${dev}/queue/iosched/fifo_batch
  echo 4 > /sys/block/${dev}/queue/iosched/read_expire
  echo 10000 > /sys/block/${dev}/queue/iosched/write_expire
  echo 10000 > /sys/block/${dev}/queue/iosched/writes_starved
  echo 1 > /sys/block/${dev}/queue/iosched/front_merges
  echo 2 > /sys/block/${dev}/queue/nomerges
#  hdparm --user-master u --security-set-pass pass /dev/${dev}
#  hdparm --user-master u --security-erase pass /dev/${dev}
#  blocks = `hdparm -N /dev/${dev} | grep disabled | cut -d ' ' -f 7 | cut -d '/' -f 1`
#  hpa_blocks = (blocks.to_i * 0.9).to_i
#  system("hdparm -Np${hpa_blocks} --yes-i-know-what-i-am-doing /dev/${dev}")
  mkfs.ext2 -b 4096 -m 0 -E stripe-width=32 -F /dev/${dev}
  mount -o noatime /dev/${dev} /mnt

  $FIO --ioengine=libaio --direct=1 --group_reporting --overwrite=1 --bwavgtime=100 --iopsavgtime=100 --filesize=${size}M --iodepth=4 --exitall --filename=/mnt/testfile --name=sequential-fill --rw=write --rate=,100m --bs=2M --loops=4 --do_verify=0 

  sleep 20
  umount /mnt
done
