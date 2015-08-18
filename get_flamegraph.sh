#!/bin/bash

cd /home/gzhang/FlameGraph
/bin/perf record -F 99 -a -g -- sleep 60
/bin/perf script | ./stackcollapse-perf.pl > out.perf-folded
./flamegraph.pl out.perf-folded > ~/perf-kernel.svg
