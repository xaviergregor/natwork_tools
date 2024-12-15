#!/bin/bash

number_ip=$1

if [ -z $number_ip ]
then
        number_ip=10
fi

netstat -plan | grep :22 | awk {'print $5'} | cut -d: -f 1 | sort | uniq -c | sort -nk 1 | tail -n $number_ip
