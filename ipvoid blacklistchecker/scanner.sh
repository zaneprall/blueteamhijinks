
#!/bin/bash

API_KEY="Goes here"
OUTPUT_FILE="output.txt"

check_ip_reputation() {
  local ip="$1"
  local response=$(curl -s -X GET "https://endpoint.apivoid.com/iprep/v1/pay-as-you-go/?key=$API_KEY&ip=$ip" -H "accept: application/json")
  echo "$ip : $response" >> "$OUTPUT_FILE"
}

ip_to_int() {
  local IFS=.
  local -a ip=($1)
  echo $((${ip[0]} * 256**3 + ${ip[1]} * 256**2 + ${ip[2]} * 256 + ${ip[3]}))
}

int_to_ip() {
  local ip=$(( $1 / 256**3 )).$(( ($1 % 256**3) / 256**2 )).$(( ($1 % 256**2) / 256 )).$(( $1 % 256 ))
  echo "$ip"
}

read -p "Enter starting IP address: " start_ip
read -p "Enter ending IP address: " end_ip

# Convert IP addresses to integers
start_int=$(ip_to_int "$start_ip")
end_int=$(ip_to_int "$end_ip")


for ip_int in $(seq "$start_int" "$end_int"); do
  ip=$(int_to_ip "$ip_int")
  check_ip_reputation "$ip"
  sleep 3 # avoid rate limiting
done

echo "IP check completed. Results saved in $OUTPUT_FILE."
