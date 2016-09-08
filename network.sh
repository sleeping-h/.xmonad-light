#!/bin/bash

n=`nmcli connection show --active | wc -l`
if [[ $n == 1 ]] 
	then
		echo "<fc=#aa0000>disconnected</fc>"
		exit 0
	fi

name=`nmcli connection show --active | awk '{ print $1 }' | tail -n 1`
device=`nmcli connection show --active | awk '{ print $4 }' | tail -n 1`

if [[ $device == eth0 ]]
	then
		echo "<icon=/home/sleeping/.xmonad/icons/net_wired.xbm/> $name"
	else
		level=`nmcli device wifi list | grep anfisa | awk '{ print $8 }'`
		echo "$level $name"
	fi

exit 0