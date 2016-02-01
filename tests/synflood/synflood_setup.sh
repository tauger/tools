#!/bin/bash

set -x

ssh test-sf01 sudo ip addr add 10.1.0.0/16 dev lo
ssh test-sf02 sudo ip addr add 10.2.0.0/16 dev lo
ssh test-sf03 sudo ip addr add 10.3.0.0/16 dev lo

ssh test-sf01 sudo ip addr add 172.16.252.1/24 dev eth4
ssh test-sf01 sudo ip link set dev eth4 up
ssh test-sf01 sudo ip addr add 172.16.253.1/24 dev eth6
ssh test-sf01 sudo ip link set dev eth6 up

ssh test-sf02 sudo ip addr add 172.16.252.2/24 dev eth4
ssh test-sf02 sudo ip link set dev eth4 up
ssh test-sf02 sudo ip addr add 172.16.253.2/24 dev eth6
ssh test-sf02 sudo ip link set dev eth6 up

ssh test-sf03 sudo ip addr add 172.16.252.3/24 dev eth4
ssh test-sf03 sudo ip link set dev eth4 up
ssh test-sf03 sudo ip addr add 172.16.253.3/24 dev eth6
ssh test-sf03 sudo ip link set dev eth6 up

ssh test-sf01 sudo ip route add blackhole 10.0.0.0/8
ssh test-sf01 sudo ip route add 10.2.0.0/21 via 172.16.252.2
ssh test-sf01 sudo ip route add 10.2.8.0/21 via 172.16.253.2
ssh test-sf01 sudo ip route add 10.3.0.0/21 via 172.16.252.3
ssh test-sf01 sudo ip route add 10.3.8.0/21 via 172.16.253.3

ssh test-sf02 sudo ip route add blackhole 10.0.0.0/8
ssh test-sf02 sudo ip route add 10.1.0.0/21 via 172.16.252.1
ssh test-sf02 sudo ip route add 10.1.8.0/21 via 172.16.253.1
ssh test-sf02 sudo ip route add 10.3.0.0/21 via 172.16.252.3
ssh test-sf02 sudo ip route add 10.3.8.0/21 via 172.16.253.3

ssh test-sf03 sudo ip route add blackhole 10.0.0.0/8
ssh test-sf03 sudo ip route add 10.1.0.0/21 via 172.16.252.1
ssh test-sf03 sudo ip route add 10.1.8.0/21 via 172.16.253.1
ssh test-sf03 sudo ip route add 10.2.0.0/21 via 172.16.252.2
ssh test-sf03 sudo ip route add 10.2.8.0/21 via 172.16.253.2

ssh test-sf01 sudo iptables -t raw -I PREROUTING -j NOTRACK
ssh test-sf01 sudo iptables -t raw -I OUTPUT -j NOTRACK

ssh test-sf02 sudo iptables -t raw -I PREROUTING -j NOTRACK
ssh test-sf02 sudo iptables -t raw -I OUTPUT -j NOTRACK

ssh test-sf03 sudo iptables -t raw -I PREROUTING -j NOTRACK
ssh test-sf03 sudo iptables -t raw -I OUTPUT -j NOTRACK

ssh test-sf01 sudo /etc/init.d/varnish stop
ssh test-sf01 sudo sv disable fst-loader
ssh test-sf01 sudo sv stop fst-loader
ssh test-sf01 sudo /etc/init.d/varnish start
ssh test-sf01 varnishadm vcl.load main /etc/varnish/default.vcl
ssh test-sf01 varnishadm vcl.use main
ssh test-sf01 varnishadm param.listen_depth 128
ssh test-sf01 varnishadm param.set listen_address "'\":80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 127.0.0.1:8001\"'"
ssh test-sf01 varnishadm start

ssh test-sf02 sudo /etc/init.d/varnish stop
ssh test-sf02 sudo sv disable fst-loader
ssh test-sf02 sudo sv stop fst-loader
ssh test-sf02 sudo /etc/init.d/varnish start
ssh test-sf02 varnishadm vcl.load main /etc/varnish/default.vcl
ssh test-sf02 varnishadm vcl.use main
ssh test-sf02 varnishadm param.set listen_depth 128
ssh test-sf02 varnishadm param.set listen_address "'\":80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 127.0.0.1:8001\"'"
ssh test-sf02 varnishadm start

ssh test-sf03 sudo /etc/init.d/varnish stop
ssh test-sf03 sudo sv disable fst-loader
ssh test-sf03 sudo sv stop fst-loader
ssh test-sf03 sudo /etc/init.d/varnish start
ssh test-sf03 varnishadm vcl.load main /etc/varnish/default.vcl
ssh test-sf03 varnishadm vcl.use main
ssh test-sf03 varnishadm param.set listen_depth 128
ssh test-sf03 varnishadm param.set listen_address "'\":80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 127.0.0.1:8001\"'"
ssh test-sf03 varnishadm start

# Set up routes on both sides
# Check route lookups
# Set up iptables rules

# Ping from SOURCE to SINK to confirm route sanity
# Ping from SINK to SOURCE to confirm route sanity

# Clean up iptables rules
# Clean up routes
# Clean up ip addresses
