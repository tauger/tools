#!/bin/bash

PERIOD=60

function compare {
    MACHINE="$1"
    TABLE="$2"
    MARKER="$3"

    PRE="`grep \"\$MARKER\" $MACHINE-$TABLE-pre.txt | head -n 1 | egrep -o '[0-9]+'`"
    POST="`grep \"\$MARKER\" $MACHINE-$TABLE-post.txt | head -n 1 | egrep -o '[0-9]+'`"

    echo -n "$MACHINE machine reports $MARKER FROM $TABLE "
    echo -n "($PRE, $POST) "
    echo -n "$(( POST - PRE )) "
    echo    "($(( (POST - PRE) / PERIOD ))/s)"
}

compare source1 netstat "segments send out"
compare source1 ethtool4 tx_packets
compare source1 ethtool4 tx_pkts_nic
compare source1 ethtool6 tx_packets
compare source1 ethtool6 tx_pkts_nic
compare source2 netstat "segments send out"
compare source2 ethtool4 tx_packets
compare source2 ethtool4 tx_pkts_nic
compare source2 ethtool6 tx_packets
compare source2 ethtool6 tx_pkts_nic
compare sink ethtool4 rx_pkts_nic
compare sink ethtool4 rx_packets
compare sink ethtool6 rx_pkts_nic
compare sink ethtool6 rx_packets
compare sink netstat "segments received"
compare sink netstat "SYN cookies sent"
