#!/bin/bash

# log file path
log_file="/var/log/discovered_devices.log"


if [ ! -f "$log_file" ]; then
    touch "$log_file"
fi


while true; do

   bluetoothctl -- power on > /dev/null &
   bluetoothctl -- discoverable yes > /dev/null & 
   bluetoothctl -- scan on > /dev/null &   
   bluetoothctl -- scan off > /dev/null &
   bluetoothctl -- poweroff > /dev/null 

    if ls /var/lib/bluetooth/*/cache/*.cache > /dev/null 2>&1; then
        grep -oP 'Device \K\w{2}:\w{2}:\w{2}:\w{2}:\w{2}:\w{2}' /var/lib/bluetooth/*/cache/*.cache | sort -u | while read -r line; do

            if grep -q "$line" "$log_file"; then
                continue
            fi


            name=$(bluetoothctl info "$line" | grep -oP 'Name: \K.*')
            rssi=$(bluetoothctl info "$line" | grep -oP 'RSSI: \K.*')
            txrate=$(bluetoothctl info "$line" | grep -oP 'Tx Power: \K.*')
            echo "$(date +'%Y-%m-%d %H:%M:%S') $line $name (RSSI: $rssi dBm, Tx Power: $txrate dBm)" >> "$log_file"
        done
    fi

    # Wait for 10
    sleep 10
done
