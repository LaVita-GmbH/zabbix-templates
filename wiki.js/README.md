# Wiki.js Zabbix Template

This Zabbix template provides comprehensive monitoring for Wiki.js instances through their GraphQL API. It monitors API connectivity, storage backend operational status, and API token expiration dates.

## Features

- **API Error Detection**: Monitors GraphQL API responses for errors
- **Storage Backend Monitoring**: Automatically discovers and monitors operational status of all configured storage backends
- **API Token Expiration Tracking**: Monitors expiration dates of active API tokens with configurable warning thresholds
- **Automated Discovery**: Dynamic discovery of storage backends and API tokens

## Prerequisites

- Zabbix Server 7.2 or higher
- Wiki.js instance with GraphQL API enabled
- Valid API token with appropriate permissions
- Network connectivity from Zabbix server/proxy to Wiki.js instance

## Installation

1. Import the template file `wikijs.yaml` into your Zabbix server
2. Navigate to **Configuration** → **Templates**
3. Click **Import** and select the template file
4. Verify the template "WikiJS via GraphQL" appears in the Templates list

## Configuration

### 1. Template Macros

Configure the following macros in the template or host level:

| Macro                 | Default Value | Description                                |
| --------------------- | ------------- | ------------------------------------------ |
| `{$WIKI.SCHEMA}`      | `https`       | Protocol to use (http/https)               |
| `{$WIKI.TOKEN}`       | `API_TOKEN`   | Wiki.js API token for authentication       |
| `{$WIKI.EXPIRY_WARN}` | `1209600`     | Warning threshold (14 days in seconds)     |
| `{$WIKI.EXPIRY_AVG}`  | `604800`      | Average threshold (7 days in seconds)      |
| `{$WIKI.EXPIRY_HIGH}` | `86400`       | High priority threshold (1 day in seconds) |

### 2. Host Configuration

1. Create a new host or use an existing one
2. Link the "WikiJS via GraphQL" template to the host
3. Set the host name to match your Wiki.js domain/IP
4. Update the macros with your specific values:
   - Set `{$WIKI.TOKEN}` to your actual Wiki.js API token
   - Adjust `{$WIKI.SCHEMA}` if not using HTTPS

### 3. API Token Setup

1. In your Wiki.js admin panel, navigate to **Administration** → **API Access**
2. Create a new API token
3. Copy the token and set it as the `{$WIKI.TOKEN}` macro value

## Monitored Items

### Static Items
- **WikiJS GraphQL Data** - Raw GraphQL API response for data processing (no history)
- **WikiJS API Error State** - Binary indicator of API errors (0 = no errors, 1 = errors present)

### Discovery Items (Auto-discovered)

#### Storage Backends
For each discovered storage backend:
- **Status of {Backend Name} Storage Backend** - Operational status ("operational" or other states)

#### API Tokens
For each active API token:
- **API Token {Name} Expiration Timestamp** - Token expiration time as Unix timestamp

## Triggers

### Static Triggers
- **WikiJS API reported an error** (HIGH) - Triggers when GraphQL API returns errors

### Dynamic Triggers

#### Storage Backend Triggers
- **Storage Backend {Name} is not operational** (AVERAGE) - Triggers when storage backend status is not "operational"

#### API Token Triggers
- **API Token {Name} Expires soon** (WARNING/AVERAGE/HIGH) - Multiple triggers based on time until expiration:
  - WARNING: 14 days before expiry
  - AVERAGE: 7 days before expiry
  - HIGH: 1 day before expiry

## Troubleshooting

### Common Issues

1. **Authentication Failed**
   - Verify `{$WIKI.TOKEN}` macro contains a valid API token
   - Ensure the token has required permissions
   - Check token expiration date

2. **No Data Received**
   - Verify `{$WIKI.SCHEMA}` and host name are correct
   - Check network connectivity to Wiki.js instance
   - Ensure GraphQL API is enabled in Wiki.js

3. **Discovery Not Working**
   - Check if storage backends are configured in Wiki.js
   - Verify API token has permissions to access storage information
   - Review Zabbix server logs for preprocessing errors
