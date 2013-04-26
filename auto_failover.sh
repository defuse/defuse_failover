#!/bin/bash

# WARNING: This script takes up to 5 minutes to execute. If it is run more
# frequently than that, race conditions might screw stuff up.

readonly FAILOVER_FILE=/tmp/failover-21222.txt
readonly FAILOVER_DOMAIN="site-one.defuse.ca"
readonly FAILOVER_PORT=80
readonly FAILOVER_START_SCRIPT=/root/defuse_failover/failover.sh
readonly FAILOVER_STOP_SCRIPT=/root/defuse_failover/undo-failover.sh
readonly TEST_DOMAIN1="google.com"
readonly TEST_DOMAIN2="yahoo.com"

if [ -e "$FAILOVER_FILE" ] ; then 
    for i in {1..3}; do
        nc -z defuse.ca 80 -w 10
        if [ $? -eq 0 ]; then
            echo "$FAILOVER_DOMAIN IS BACK UP! STOPPING FAILOVER."
            $FAILOVER_STOP_SCRIPT
            rm "$FAILOVER_FILE"
            exit 0
        fi
        sleep 60
    done
    echo "$FAILOVER_DOMAIN is still down."
else
    for i in {1..3}; do
        nc -z "$FAILOVER_DOMAIN" $FAILOVER_PORT -w 10
        if [ $? -eq 0 ]; then
            echo "Good connection to $FAILOVER_DOMAIN. Quitting."
            exit 0
        fi

        # Make sure we have internet access.
        nc -z "$TEST_DOMAIN1" $FAILOVER_PORT -w 10
        if [ $? -ne 0 ]; then
            echo "Can't connect to $TEST_DOMAIN1. Quitting."
            exit 0
        fi
        nc -z "$TEST_DOMAIN2" $FAILOVER_PORT -w 10
        if [ $? -ne 0 ]; then
            echo "Can't connect to $TEST_DOMAIN2. Quitting."
            exit 0
        fi

        sleep 60
    done

    echo "$FAILOVER_DOMAIN IS DOWN. STARTING FAILOVER."

    touch "$FAILOVER_FILE"
    $FAILOVER_START_SCRIPT
fi
