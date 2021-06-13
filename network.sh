#!/bin/bash

nmcli connection show --active |grep wifi| awk '{print $1}'
# for dns
# ping -q -c 1 -W 1 ya.ru > /dev/null && echo 'up' || echo 'down'

exit 0
