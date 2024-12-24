# Dig Dynamite

A 'quick and dirty' script to use multiple dig commands to quickly enumerate DNS records. 

Runs a bunch of dig commands in succession to check for:

- A
- AAAA
- CNAME
- MX
- NS
- PTR
- SOA
- TXT (Including a specific theoretically redundant DMARC check using nslookup)
- SRV
- CAA

## Usage:

./dig-dyn.sh -d example.co.uk 

<img src="dig-dynamite.png" alt="logo-unimportant" width="200"/>
