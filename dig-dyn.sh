#!/bin/bash

# Color definitions
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
BOLD="\033[1m"
UNDERLINE="\033[4m"
RESET="\033[0m"




echo "▗▄▄▄ ▗▄▄▄▖ ▗▄▄▖    ▗▄▄▄▗▖  ▗▖▗▖  ▗▖ ▗▄▖ ▗▖  ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖";
echo "▐▌  █  █  ▐▌       ▐▌  █▝▚▞▘ ▐▛▚▖▐▌▐▌ ▐▌▐▛▚▞▜▌  █    █  ▐▌   ";
echo "▐▌  █  █  ▐▌▝▜▌    ▐▌  █ ▐▌  ▐▌ ▝▜▌▐▛▀▜▌▐▌  ▐▌  █    █  ▐▛▀▀▘";
echo "▐▙▄▄▀▗▄█▄▖▝▚▄▞▘    ▐▙▄▄▀ ▐▌  ▐▌  ▐▌▐▌ ▐▌▐▌  ▐▌▗▄█▄▖  █  ▐▙▄▄▖";
echo "                                                             ";





# Function to display usage
usage() {
    echo -e "${CYAN}Usage:${RESET} $0 [-d domain]"
    echo -e "  -d domain   Specify the domain to look up"
    echo -e "  If no domain is provided with -d, the script will prompt for input."
}

# Parse options
while getopts ":d:h" opt; do
    case $opt in
        d) domain="$OPTARG" ;;
        h)
            usage
            exit 0
            ;;
        \?)
            echo -e "${RED}Error:${RESET} Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo -e "${RED}Error:${RESET} Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done

# Prompt for domain if not provided
if [[ -z "$domain" ]]; then
    read -p "Enter the domain name you want to look up: " domain
    if [[ -z "$domain" ]]; then
        echo -e "${RED}Error:${RESET} No domain entered. Exiting."
        exit 1
    fi
fi

# List of DNS record types to query
record_types=("A" "AAAA" "CNAME" "MX" "PTR" "NS" "SRV" "SOA" "TXT" "CAA" "DS")

# Perform lookups
echo -e "${GREEN}Looking up DNS records for:${RESET} ${BLUE}$domain${RESET}"
for record in "${record_types[@]}"; do
    echo -e "${CYAN}${BOLD}${UNDERLINE}Identified $record records for $domain:${RESET}"
    output=$(dig +nocmd "$domain" "$record" +noall +answer)
    if [[ -z "$output" ]]; then
        echo -e "${RED}No records identified.${RESET}"
    else
        echo -e "$output"
    fi
    echo ""
done

# Check for DMARC record
echo -e "${CYAN}Checking for DMARC record...${RESET}"
dmarc_record=$(nslookup -type=TXT "_dmarc.$domain" 2>/dev/null | grep -E '^_dmarc' || echo "No DMARC record found.")
if [[ "$dmarc_record" == "No DMARC record found." ]]; then
    echo -e "${RED}No DMARC record found for ${BLUE}$domain${RESET}"
else
    echo -e "${GREEN}DMARC record found:${RESET}"
    echo -e "$dmarc_record"
fi

# Script complete
echo -e "${GREEN}DNS lookup completed for ${BLUE}$domain${RESET}"

