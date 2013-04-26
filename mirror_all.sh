#!/bin/bash

# DO NOT mirror if a failover is in progress.
if [ -f "/var/named/db.defuse.before-fail" ]; then
    echo "FAILOVER IN PROGRESS. NOT MIRRORING."
    exit 1
fi

readonly DEFUSE_REAL_URL="http://defuse.ca/"
readonly DEFUSE_STAGE_URL="http://defuse.h.defuse.ca/"

readonly CRACKSTATION_REAL_URL="http://crackstation.net/"
readonly CRACKSTATION_STAGE_URL="http://crackstation.h.defuse.ca/"

if [ $# -eq 0 ] || [ $1 != "stage" ]; then
    echo "Mirroring from REAL website..."
    CRACKSTATION_URL=$CRACKSTATION_REAL_URL
    DEFUSE_URL=$DEFUSE_REAL_URL
else
    echo "Mirroring from STAGING website..."
    CRACKSTATION_URL=$CRACKSTATION_STAGE_URL
    DEFUSE_URL=$DEFUSE_STAGE_URL
fi

/root/defuse_failover/mirror.sh "$CRACKSTATION_URL" /var/www/mirror/crackstation.net/ 

ruby /root/defuse_failover/add_banner.rb /var/www/mirror/crackstation.net/ <<BANNER
<div style="width: 100%;
            background-color: #FFFF00;
            color: black;
            font-family: verdana, tahoma, arial, helvetica, sans-serif;
            font-size: 10pt;
            padding: 10px;
            margin: 0px;">
<b>This is a cached copy of crackstation.net</b> being served by a backup web server.
You will normally only see this when the main web server has unexpectedly gone
offline. All interactive functionality has been disabled and some information
may be out of date. 
</div>
BANNER


/root/defuse_failover/mirror.sh "$DEFUSE_URL" /var/www/mirror/defuse.ca/ 


ruby /root/defuse_failover/add_banner.rb /var/www/mirror/defuse.ca/ <<BANNER
<div style="width: 100%;
            background-color: #FFFF00;
            color: black;
            font-family: font-family: verdana, tahoma, arial, helvetica, sans-serif;
            padding: 10px;
            margin: 0px;">
<b>This is a cached copy of defuse.ca</b> being served by a backup web server.
You will normally only see this when the main web server has unexpectedly gone
offline. All interactive functionality has been disabled and some information
may be out of date. 
</div>
BANNER
