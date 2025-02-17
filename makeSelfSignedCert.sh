#!/bin/bash
# This script determines the external IP address and creates a self-signed certificate
# with the IP address as the Common Name.

# Extract the first non-loopback IPv4 address from ifconfig output.
# This regex works for both "inet addr:" and "inet" style outputs.
ADDRESS_A=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]+\.){3}[0-9]+' | \
            grep -Eo '([0-9]+\.){3}[0-9]+' | \
            grep -v '^127\.' | head -n 1)

if [ -z "$ADDRESS_A" ]; then
  echo "Error: Could not determine the external IP address."
  exit 1
fi

echo "Using external IP address: $ADDRESS_A"

# Generate a self-signed certificate with a 10-year validity period.
# The -subj flag sets the certificate subject; here we set only the Common Name (CN) to ADDRESS_A.
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx.key \
  -out /etc/ssl/certs/nginx.crt \
  -days 3650 \
  -subj "/CN=${ADDRESS_A}"

echo "Certificate and key have been generated."
