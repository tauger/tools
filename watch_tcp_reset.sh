#!/bin/bash

echo 'p:kprobes/tcp_send_active_reset tcp_send_active_reset' >> /sys/kernel/debug/tracing/kprobe_events
echo 'p:kprobes/tcp_v4_send_reset tcp_v4_send_reset' >> /sys/kernel/debug/tracing/kprobe_events

perf stat -a -e "kprobes:*" sleep $1
