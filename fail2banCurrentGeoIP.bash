#!/bin/bash

sudo fail2ban-client status sshd | grep "Banned IP list:" | sed 's/`- Banned IP list://g' | xargs -n 1 geoiplookup | sed 's/GeoIP Country Edition://g'

