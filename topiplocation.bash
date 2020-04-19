#!/bin/bash
## all Fail2Ban Log should be logged into /var/log/fail2ban.log then this will work
## you need geoiplookup to get it runningyou can install it with sudo apt install geoip-bin
cat /var/log/fail2ban.log* | grep Ban | sed 's/.*[Bb]an \(.*\)/\1/' | uniq | while read line; do geoiplookup $line; done | sort | uniq -c | sort -nr
