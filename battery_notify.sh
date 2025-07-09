# send notification if battery < 20% and is not charging
#!/bin/bash

#variablee to track if notification is already sent so it doesn't spam every 60 sec after battery lower than 20%
notified=0

while true; do
    battery_path=$(find /sys/class/power_supply/ -name 'BAT*' | head -n1)
    battery_level=$(cat "$battery_path/capacity")
    charging_status=$(cat "$battery_path/status")

    if [[ "$battery_level" -le 20 && "$charging_status" != "Charging" ]]; then
        if [[ $notified -eq 0 ]]; then
            notify-send "⚠️ Battery Low" "Battery level is at ${battery_level}%!" -u critical
            notified=1
        fi
    else
        notified=0
    fi

    sleep 60
done