#!/bin/bash

ssh test-sf01 sudo ethtool -S eth4 > source1-ethtool4-pre.txt
ssh test-sf01 sudo ethtool -S eth6 > source1-ethtool6-pre.txt
ssh test-sf01 netstat --stat --tcp > source1-netstat-pre.txt

ssh test-sf03 sudo ethtool -S eth4 > source2-ethtool4-pre.txt
ssh test-sf03 sudo ethtool -S eth6 > source2-ethtool6-pre.txt
ssh test-sf03 netstat --stat --tcp > source2-netstat-pre.txt

ssh test-sf02 sudo ethtool -S eth4 > sink-ethtool4-pre.txt
ssh test-sf02 sudo ethtool -S eth6 > sink-ethtool6-pre.txt
ssh test-sf02 netstat --stat --tcp > sink-netstat-pre.txt

(
ssh test-sf01 <<'EOT'
for j in `seq 0 3` `seq 8 11`
do
    sudo hping3 -n --flood --spoof 10.1.$j.1 -S -p 80 10.2.$j.3 &
done

sleep 60

kill `jobs -p`

wait
EOT
) &

(
ssh test-sf03 <<'EOT'
for j in `seq 0 15`
do
    sudo hping3 -n --flood --spoof 10.3.$j.1 -S -p 80 10.2.$j.3 &
done

sleep 60

kill `jobs -p`

wait
EOT
) &

wait

ssh test-sf01 sudo ethtool -S eth4 > source1-ethtool4-post.txt
ssh test-sf01 sudo ethtool -S eth6 > source1-ethtool6-post.txt
ssh test-sf01 netstat --stat --tcp > source1-netstat-post.txt

ssh test-sf03 sudo ethtool -S eth4 > source2-ethtool4-post.txt
ssh test-sf03 sudo ethtool -S eth6 > source2-ethtool6-post.txt
ssh test-sf03 netstat --stat --tcp > source2-netstat-post.txt

ssh test-sf02 sudo ethtool -S eth4 > sink-ethtool4-post.txt
ssh test-sf02 sudo ethtool -S eth6 > sink-ethtool6-post.txt
ssh test-sf02 netstat --stat --tcp > sink-netstat-post.txt
