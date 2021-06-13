#!/bin/bash

pgrep -c zoom && killall zoom || zoom &

exit 0
