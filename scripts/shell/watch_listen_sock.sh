#!/bin/bash

echo 'p:kprobes/inet_csk_listen_start inet_csk_listen_start' >> /sys/kernel/debug/tracing/kprobe_events
echo 'p:kprobes/inet_listen inet_listen' >> /sys/kernel/debug/tracing/kprobe_events

perf stat -a -e "kprobes:*" sleep $1

# clean up these kprobes
perf probe -d "kprobes:*"
