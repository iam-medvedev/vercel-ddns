#!/bin/bash

# Vercel Dynamic DNS
# https://github.com/iam-medvedev/vercel-ddns

source ./dns.config

# Check if jq is installed
if ! command -v jq >/dev/null; then
  echo "Error: 'jq' is not installed. Please install 'jq' to run this script."
  exit 1
fi

# Returns current IP
get_current_ip() {
  local ip
  ip=$(curl -s http://whatismyip.akamai.com/)
  echo $ip
}

# Function to check if subdomain exists
check_subdomain_exists() {
  local subdomain="$1"
  local response
  response=$(curl -sX GET "https://api.vercel.com/v4/domains/$DOMAIN_NAME/records" \
    -H "Authorization: Bearer $VERCEL_TOKEN" \
    -H "Content-Type: application/json")

  local record_id
  record_id=$(echo "$response" | jq -r ".records[] | select(.name == \"$subdomain\") | .id")
  if [[ -n "$record_id" ]]; then
    # Return record ID if exists
    echo "$record_id"
  else
    # Subdomain does not exist
    return 1
  fi
}

# Updates dns record
update_dns_record() {
  local ip="$1"
  local record_id="$2"
  local response
  response=$(curl -sX PATCH "https://api.vercel.com/v1/domains/records/$record_id" \
    -H "Authorization: Bearer $VERCEL_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "comment": "vercel-ddns",
      "name": "'$SUBDOMAIN'",
      "type": "A",
      "value": "'$ip'",
      "ttl": 60
    }')

  # Check for errors in the response
  if [[ "$response" == *"error"* ]]; then
    local error_message
    error_message=$(echo "$response" | jq -r '.error.message')
    echo "⚠️ Error updating DNS record: $error_message"
    exit 1
  fi
}

# Creates dns record
create_dns_record() {
  local ip="$1"
  local response
  response=$(curl -sX POST "https://api.vercel.com/v4/domains/$DOMAIN_NAME/records" \
    -H "Authorization: Bearer $VERCEL_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "comment": "vercel-ddns",
      "name": "'$SUBDOMAIN'",
      "type": "A",
      "value": "'$ip'",
      "ttl": 60
    }')

  # Check for errors in the response
  if [[ "$response" == *"error"* ]]; then
    local error_message
    error_message=$(echo "$response" | jq -r '.error.message')
    echo "⚠️ Error creating DNS record: $error_message"
    exit 1
  fi
}

# Get current IP
ip=$(get_current_ip)
echo "Updating IP: $ip"

# Check if subdomain exists
record_id=$(check_subdomain_exists "$SUBDOMAIN")
if [[ -n "$record_id" ]]; then
  echo "Record for $SUBDOMAIN already exists (id: $record_id). Updating..."
  update_dns_record "$ip" "$record_id"
else
  echo "Record for $SUBDOMAIN does not exist. Creating..."
  create_dns_record "$ip"
fi

echo "🎉 Done!"
