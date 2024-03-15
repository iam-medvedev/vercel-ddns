# Vercel Dynamic DNS

Simple script for exposing a local server with [Vercel DNS](https://vercel.com/docs/custom-domains).
It runs on CRON, checking the current IP address and updating DNS records for your domain.

## Installation

1. Ensure that you have [jq](https://github.com/jqlang/jq) installed
2. Download `dns-sync.sh`
3. Move `dns.config.example` to `dns.config`
4. Edit the configuration variables as required
5. Open the cron settings using the command `crontab -e`
6. Add the following line to the cron job: `*/15 * * * * /path-to/vercel-ddns/dns-sync.sh`

## Usage example

```sh
# Creating
➜  ./dns-sync.sh
Updating IP: x.x.x.x
Record for SUBDOMAIN does not exist. Creating...
🎉 Done!

# Updating
➜  ./dns-sync.sh
Updating IP: x.x.x.x
Record for SUBDOMAIN already exists (id: rec_xxxxxxxxxxxxxxxxxxxxxxxx). Updating...
🎉 Done!
```
