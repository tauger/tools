#!/bin/bash

if test $0 == "bash" || test $0 == "-bash"; then
    echo "This script must be executed, not sourced"
    return
fi
usage="Usage:\n  $0 <host> <port> <time in seconds to run> <num clients> <cipher> \nExample:\n  $0 localhost 443 60 30 AES128-SHA"

# take some arguments
if test $# != 5; then
    echo -e $usage
    exit 1
fi

#_openssl=`pwd`/openssl-1.0.1e/apps/openssl
_openssl=/home/gzhang/haproxy_test/bin/openssl
_host=$1 || { echo -e $usage; exit 1; }
_port=$2 || { echo -e $usage; exit 1; }
_time=$3 || { echo -e $usage; exit 1; }
_ncli=$4 || { echo -e $usage; exit 1; }
_cipher=$5 || { echo -e $usage; exit 1; }


cmd="                    \
$_openssl s_time           \
  -connect $_host:$_port   \
  -new                   \
  -cipher $_cipher	\
  -nbio                  \
  -time $_time"

echo Running the following command using $_ncli clients: $cmd

rm -rf ./.test_*
starttime=$(date +%s)
for (( i = 0; i < ${_ncli}; i++ )); do
    $cmd > .test_$(($_port))_$i &
done

waitstarttime=$(date +%s)
# wait until all processes complete
while [ $(ps -ef | grep "openssl s_time" | wc -l) != 1 ];
do
    sleep 1
done

total=$(cat ./.test_$(($_port))* | awk '(/^[0-9]* connections in [0-9]* real/){ total += $1/$4 } END {print total}')
echo $total CPS
printf "Finished in %d seconds (%d seconds waiting for procs to start)\n" $(($(date +%s) - $starttime)) $(($waitstarttime - $starttime))
