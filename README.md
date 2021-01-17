# Vercel Dynamic DNS

Script for exposing local server with [Vercel DNS](https://vercel.com/docs/custom-domains). It runs every 15 minutes, checking current IP address and updates DNS records for your domain.

## Installation

1. Download
2. Move `dns.config.example` into `dns.config`
3. Edit config
4. Open cron settings `crontab -e`
5. Add this line `*/15 * * * * /home/username/vercel-ddns/dns-sync.sh`
