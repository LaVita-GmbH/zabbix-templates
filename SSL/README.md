# Basic SSL Certificate Check

## Description

This Zabbix template monitors the expiry of SSL certificates. It is designed to be used with an external script, `certcheck.sh`, which retrieves the certificate details.

## Features

-   **Certificate Expiry (Seconds):** Uses the `certcheck.sh` script to determine the number of seconds remaining until the SSL certificate expires. This is the master item.
-   **Certificate Expiry Date (Human-Readable):** A dependent item that converts the expiry time (in seconds) into a human-readable date format (YYYY-MM-DD).
-   **HTTPS Service Check (Disabled by Default):** A simple check to verify if the HTTPS service is running on the specified host and port. This item is disabled by default and can be enabled if needed.
-   **Triggers:**
    -   **Warning:** Certificate expires in 28 days.
    -   **Average:** Certificate expires in 14 days.
    -   **High:** Certificate expires in 7 days.
-   **Configurable Port:** The SSL port can be configured using the `{$SSL_PORT}` macro (default is 443).

## Requirements

-   **Zabbix Server/Proxy:** The Zabbix server or a Zabbix proxy must be able to execute the external script.
-   **`certcheck.sh` script:** This script must be placed in the Zabbix external scripts directory (e.g., `/usr/lib/zabbix/externalscripts/`) on the Zabbix server or proxy that will be running the checks.
    -   The script can be found in this repository at `SSL/certcheck.sh`.
-   **`openssl`:** The `openssl` command-line tool must be installed and accessible to the user running the Zabbix server/proxy, as it is used by the `certcheck.sh` script.

## Installation

1.  **Copy the script:**
    -   Copy the `certcheck.sh` script from the `SSL/` directory of this repository to your Zabbix external scripts directory. For example:
        ```bash
        cp SSL/certcheck.sh /usr/lib/zabbix/externalscripts/
        ```
    -   Ensure the script is executable:
        ```bash
        chmod +x /usr/lib/zabbix/externalscripts/certcheck.sh
        ```
2.  **Import the Template:**
    -   Import the `basic_ssl_check.yaml` file into your Zabbix instance (Configuration > Templates > Import).
3.  **Link to Hosts:**
    -   Link the "Template Basic SSL Cert Check" template to the hosts you want to monitor.
4.  **Adjust Macros (Optional):**
    -   If your SSL services are not running on the default port 443, adjust the `{$SSL_PORT}` macro on the host or template level.
    -   The `{$SNI}` macro defaults to `{HOST.NAME}` and is used by the `certcheck.sh` script for Server Name Indication. Adjust if necessary.

## Macros

-   `{$SSL_PORT}`: The port number for SSL connections (Default: `443`).
-   `{$SNI}`: Server Name Indication, defaults to the host's name (Default: `{HOST.NAME}`).
-   `{$SNI_TIME_WRN}`: Threshold for the "Warning" trigger (Default: `2419200` seconds / 28 days).
-   `{$SNI_TIME_AVG}`: Threshold for the "Average" trigger (Default: `1209600` seconds / 14 days).
-   `{$SNI_TIME_HIGH}`: Threshold for the "High" trigger (Default: `604800` seconds / 7 days).
