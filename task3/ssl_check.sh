#!/bin/bash

# Function to check SSL certificate expiry
check_ssl_expiry() {
    url=$1
    email=$2
    expiry_date=$(date -d "$(: | openssl s_client -servername $url -connect $url:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f 2)" '+%s')
    current_date=$(date '+%s')
    expiration_in_seconds=$(( $expiry_date - $current_date ))
    expiration_in_months=$(( $expiration_in_seconds / 60 / 60 / 24 / 30 ))

    if [ $expiration_in_months -le 2 ]; then
        # Send email
        echo -e "To:$email\nSubject: SSL certificate for $url\n\n will expire within 2 months. Expires on: $(date -d @$expiry_date)" | ssmtp $email
    else
        echo -e "To:$email\nSubject: SSL certificate for $url\n\n is valid. Expires on: $(date -d @$expiry_date)" | ssmtp $email
    fi
}

# Check if enough arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <website_URL> <email>"
    exit 1
fi

# Call the function with provided arguments
check_ssl_expiry "$1" "$2"

