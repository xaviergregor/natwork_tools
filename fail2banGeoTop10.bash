#!/bin/bash

sudo fail2ban-client status sshd | grep "Banned IP list:" | awk '{print $5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15}' | xargs -n 1 geoiplookup | awk '{print $4,$5,$6,$7,$8,$9,$10,$11}' 
