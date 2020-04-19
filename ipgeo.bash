#!/bin/bash

sudo fail2ban-client status sshd | grep "Banned IP list:" | awk '{print $5}' > ip.txt && cat ip.txt | xargs -I% curl -s http://ipinfo.io/%

