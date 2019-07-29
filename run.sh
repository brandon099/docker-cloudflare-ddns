#!/bin/bash

if [[ -z "${CF_API_KEY}" ]]; then
  api_key=""   # Top right corner, "My profile" > "API Tokens" > Create Token. Be sure to have the proper permissions to edit the Zone entries
else
  api_key="$CF_API_KEY"
fi

if [[ -z "${CF_ZONE_ID}" ]]; then
  zone_id="" # Can be found in the "Overview" tab of your domain on the right lower side of the page
else
  zone_id="$CF_ZONE_ID"
fi

if [[ -z "${CF_RECORD_NAME}" ]]; then
  record_name=""                     # Which record you want to be synced
else
  record_name="$CF_RECORD_NAME"
fi

ip=$(curl -s https://ifconfig.io/ip)
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?name=$record_name" -H "Authorization: Bearer $api_key" -H "Content-Type: application/json")
cf_ip=$(echo "$record" | grep -Po '(?<="content":")[^"]*' | head -1)
record_id=$(echo "$record" | grep -Po '(?<="id":")[^"]*' | head -1)

if [[ $record == *"\"count\":0"* ]]; then
  >&2 echo -e "Specified DNS record does not exist"
  exit 1
fi

if [ "$ip" == "$cf_ip" ]; then
  exit 0
fi

update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" -H "Authorization: Bearer $api_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_id\",\"type\":\"A\",\"proxied\":false,\"name\":\"$record_name\",\"content\":\"$ip\"}")

case "$update" in
*"\"success\":false"*)
  >&2 echo -e "Update failed for $record_name. Results:\n$update"
  exit 1;;
esac
