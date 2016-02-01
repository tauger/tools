#!/bin/bash

HOST=$1

ssh $HOST sudo iptables -t raw -I PREROUTING -j NOTRACK
ssh $HOST sudo iptables -t raw -I OUTPUT -j NOTRACK

ssh $HOST sudo /etc/init.d/varnish stop
ssh $HOST sudo sv disable fst-loader
ssh $HOST sudo sv stop fst-loader
ssh $HOST sudo /etc/init.d/varnish start
ssh $HOST varnishadm vcl.load main /etc/varnish/default.vcl
ssh $HOST varnishadm vcl.use main
ssh $HOST varnishadm param.set listen_depth 128
ssh $HOST varnishadm param.set listen_address "'\":80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 :80 127.0.0.1:8001\"'"
ssh $HOST varnishadm start
