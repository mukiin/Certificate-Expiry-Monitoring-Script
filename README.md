# Certificate Expiry Monitoring Script

## Description

This Bash script monitors the expiration dates of SSL/TLS certificates and sends metrics to a Prometheus Pushgateway. It checks the expiration date of each certificate and categorizes them into three metrics: valid certificates, certificates expiring soon, and expired certificates. Additionally, it provides guidance on setting up Grafana dashboards and alerts based on these metrics.

## Prerequisites

- Bash shell environment
- OpenSSL installed
- Curl command-line tool installed
- Access to the certificates to be monitored
- Knowledge of the Pushgateway address
- Grafana installed and configured

## Configuration

Before using this script, ensure the following parameters are properly configured:

- `cert_dir`: Array containing the paths to the SSL/TLS certificate files.
- `pushgateway_address`: The address of the Prometheus Pushgateway where metrics will be sent.
- Grafana dashboard and alert configurations (see below).

## Usage

1. Make sure the script is executable: `chmod +x certificate_expiry_monitoring.sh`
2. Configure the `cert_dir` array with the paths to your SSL/TLS certificate files.
3. Run the script: `./certificate_expiry_monitoring.sh`
4. Check the Pushgateway for the generated metrics.
5. Set up Grafana dashboards and alerts (see below).

## Script Logic

1. The script iterates through the specified certificate paths.
2. For each certificate, it checks if the certificate files exist.
3. If the certificate files exist, it extracts the expiration date and calculates the remaining days until expiration.
4. Based on the remaining days, it categorizes the certificate into valid, expiring soon, or expired.
5. It constructs metrics strings for each category.
6. Finally, it sends the metrics to the Pushgateway using Curl commands.

## Grafana Dashboard and Alerts

### Dashboard Configuration

1. Log in to Grafana and navigate to the Dashboards section.
2. Create a new dashboard or edit an existing one.
3. Add Prometheus as a data source if not already configured.
4. Create panels for each of the following metrics:
   - Valid Certificates
   - Certificates Expiring Soon
   - Expired Certificates
5. Customize the panels to display the relevant metrics and visualize them as needed.

### Alert Configuration

1. In Grafana, navigate to the Alerting section.
2. Create a new alert or edit an existing one.
3. Set the conditions based on the metrics received from Prometheus:
   - For example, create an alert condition to trigger when the number of certificates expiring soon exceeds a certain threshold.
4. Configure the notification channels to receive alerts, such as email, Slack, or PagerDuty.

## Note

- Ensure that the Pushgateway is properly configured and accessible from the machine running the script.
- Customize the configuration according to your specific SSL/TLS certificates, Pushgateway setup, Grafana dashboard, and alert requirements.
- Replace placeholders such as "/path/to/your/certificate" and "localhost:9091" with actual values before using the script.
- This script assumes basic knowledge of SSL/TLS certificates, Prometheus Pushgateway, and Grafana.
- Ensure that the script is executed with appropriate permissions to access the certificate files and send requests to the Pushgateway.
