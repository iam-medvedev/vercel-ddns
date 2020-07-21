#!/bin/bash

source ./dns.config

# 1. Get current IP
IP=$(curl -s http://whatismyip.akamai.com/)
echo "$IP"

# 2. Create/update DNS record
curl -X POST "https://api.vercel.com/v2/domains/$DOMAIN_NAME/records" \
  -H "Authorization: Bearer $VERCEL_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "'$SUBDOMAIN'",
  "type": "A",
  "value": "'$IP'",
  "ttl": 60
}'

echo ''
echo "🎉 Done!"
