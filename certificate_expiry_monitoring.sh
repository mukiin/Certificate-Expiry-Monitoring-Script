#!/bin/bash

# Path to certificates
cert_dir=(
   "/path/to/your/certificate"
)

# PUSHGATEWAY address
pushgateway_address="localhost:9091"

# Metrics variables initialization
valid_cert_metrics=""
expiring_cert_metrics=""
expired_cert_metrics=""

# Check paths for metrics
for cert_path in "${cert_dir[@]}"; do

    # Check if certificate files exist
    if [ -f "$cert_path.crt" ] && [ -f "$cert_path.key" ]; then
        cert_file="$cert_path.crt"
        key_file="$cert_path.key"

        # Check expiration date of certificates
        expiration_date=$(openssl x509 -enddate -noout -in "$cert_file" | cut -d "=" -f 2)
        expiration_timestamp=$(date -d "$expiration_date" +%s)
        current_timestamp=$(date +%s)

        # Extract certificate names
        cert_name=$(basename "$cert_path")

        # Check current time against certificate expiration time
        if [ $expiration_timestamp -lt $current_timestamp ]; then
            expired_cert_metrics+="\ninvalid_certificates{cert_file=\"$cert_name\"} 1"
        else   
            remaining_seconds=$((expiration_timestamp - current_timestamp))
            remaining_days=$((remaining_seconds / 86400))

            if [ $remaining_days -gt 30 ]; then
                valid_cert_metrics+="\nvalid_certificates{cert_file=\"$cert_name\"} 1"
            else
                expiring_cert_metrics+="\ncertificates_expiring_soon{cert_file=\"$cert_name\"} 1"
            fi
        fi

    else
        echo "Certificate does not exist at location: $cert_path"
    fi

done

# Send metrics to Pushgateway
echo -e "$valid_cert_metrics" | curl --data-binary @- "$pushgateway_address/metrics/job/valid_certificates"
echo -e "$expiring_cert_metrics" | curl --data-binary @- "$pushgateway_address/metrics/job/certificates_expiring_soon"
echo -e "$expired_cert_metrics" | curl --data-binary @- "$pushgateway_address/metrics/job/invalid_certificates"

exit 0
