# Simple Cloudflare DDNS UPDATER

Simple utility to update a DNS record in Cloudflare allowing you to use Cloudflare for DDNS.

### Usage
```docker build . -t cloudflare-ddns```

```sudo docker run -e CF_API_KEY='' -e CF_ZONE_ID='' -e CF_RECORD_NAME='' cloudflare-ddns```

