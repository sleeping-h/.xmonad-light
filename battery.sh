#!/bin/bash

lvl=`acpi | cut -d ' ' -f4 | tr -d '%,'`

echo -n "<fn=2>$lvl</fn>"%

case `acpi | cut -d ' ' -f3` in
    Charging,) echo " on" ;;
    Discharging,) echo " off" ;;
esac

