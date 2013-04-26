#!/bin/bash

ssh root@site-one.defuse.ca "service bind9 restart"

mv /var/named/db.defuse.before-fail /var/named/db.defuse
mv /var/named/db.crackstation.before-fail /var/named/db.crackstation

chown bind:bind /var/named/db.defuse
chmod 644 /var/named/db.defuse

chown bind:bind /var/named/db.crackstation
chmod 644 /var/named/db.crackstation

chown bind:bind /var/named

service bind9 restart
