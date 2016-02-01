#!/bin/bash

echo 'p:kprobes/sha_transform sha_transform' >> /sys/kernel/debug/tracing/kprobe_events
echo 'p:kprobes/sha1_transform_ssse3 sha1_transform_ssse3' >> /sys/kernel/debug/tracing/kprobe_events

perf stat -a -e "kprobes:*" modprobe tcrypt mode=303 sec=2
#perf stat -a -e "kprobes:*" sleep $1

# clean up these kprobes
perf probe -d "kprobes:*"
