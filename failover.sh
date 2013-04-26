#!/bin/bash

/root/defuse_failover/alert/alert.sh repeat /root/defuse_failover/alert/sounds/Hailing.mp3

ORIGINAL_IP=$(egrep "^\s*A" /var/named/db.defuse | rev | cut -f 1 | rev)
BACKUP_IP=$(host -t A failover.defuse.ca | cut -d " " -f 4)


if [ -f "/var/named/db.defuse.before-fail" ]; then
    echo "defuse.ca config backup already exists. Exiting."
    exit 1
fi
cp /var/named/db.defuse /var/named/db.defuse.before-fail
sed -i -r "s/^(\\s*A\\s+)$ORIGINAL_IP/\1 $BACKUP_IP/g" /var/named/db.defuse
sed -i 's/.*$TTL.*/$TTL 600/' /var/named/db.defuse
chown root:root /var/named/db.defuse
chmod 444 /var/named/db.defuse


if [ -f "/var/named/db.crackstation.before-fail" ]; then
    echo "crackstation.net config backup already exists. Exiting."
    exit 1
fi
cp /var/named/db.crackstation /var/named/db.crackstation.before-fail
sed -i -r "s/^(\\s*A\\s+)$ORIGINAL_IP/\1 $BACKUP_IP/g" /var/named/db.crackstation
sed -i 's/.*$TTL.*/$TTL 600/' /var/named/db.crackstation
chown root:root /var/named/db.defuse
chmod 444 /var/named/db.crackstation

chown root:root /var/named

service bind9 restart

# Stop the main DNS server so all requests come here.
ssh root@site-one.defuse.ca "service bind9 stop"

