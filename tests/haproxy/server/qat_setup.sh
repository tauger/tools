#!/bin/bash

# ensure rss queue
#/home/gzhang/set_irq_affinity.intel p3p1 default
#/home/gzhang/set_irq_affinity.intel p3p2 default
#/home/gzhang/set_irq_affinity.intel p6p1 default
#/home/gzhang/set_irq_affinity.intel p6p2 default

# load the qat drivers
insmod /QAT/QAT1.6/build/icp_qa_al.ko
insmod /QAT/QAT1.6/build/qat_mem.ko

# stop unnecessary services
service st-healthcheck stop
service fst-loader stop
service irqbalance stop

# start qat service
service qat_service start
service qat_service status


# start the backend 
/home/gzhang/httpterm-1.7.2/httpterm -d -L 0.0.0.0:9999 &



