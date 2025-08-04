# Kubernetes Prometheus Alertmanager Zabbix Template

This Zabbix template provides monitoring capabilities for Prometheus Alertmanager in Kubernetes environments. It monitors alert status, tracks firing alerts, and provides automated discovery of Prometheus alerts.

- [Kubernetes Prometheus Alertmanager Zabbix Template](#kubernetes-prometheus-alertmanager-zabbix-template)
  - [Features](#features)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
    - [Macros](#macros)
    - [Host Configuration](#host-configuration)
  - [Monitored Items](#monitored-items)
    - [Static Items](#static-items)
    - [Discovery Items (Auto-discovered)](#discovery-items-auto-discovered)
  - [Triggers](#triggers)
    - [Static Triggers](#static-triggers)
    - [Dynamic Triggers (Per Alert)](#dynamic-triggers-per-alert)
  - [Troubleshooting](#troubleshooting)
    - [Common Issues](#common-issues)
    - [Testing](#testing)
  - [Alert Severity Mapping](#alert-severity-mapping)


## Features

- **Alert Status Monitoring**: Monitors the overall health of Prometheus alerts API
- **Watchdog Alert Tracking**: Dedicated monitoring for the Prometheus Watchdog alert
- **Dynamic Alert Discovery**: Automatically discovers and monitors all Prometheus alerts (except Watchdog)
- **Severity-based Triggers**: Different trigger priorities based on alert severity (warning, critical)
- **Alert State Tracking**: Monitors when alerts are firing and their duration

## Prerequisites

- Zabbix Server 6.4 or higher
- Prometheus with Alertmanager running in Kubernetes
- Network connectivity from Zabbix server/proxy to Prometheus API endpoint
- [Zabbix Kubernetes Proxy](https://www.zabbix.com/de/integrations/kubernetes) is recommended, but not required

## Installation

1. Import the template file `prometheus_alerts_zabbix.yaml` into your Zabbix server
2. Navigate to **Configuration** → **Templates** 
3. Click **Import** and select the template file
4. Verify the template "Kubernetes Prometheus Alertmanager" appears in the Templates list

## Configuration

### Macros

The template uses the following macro to configure the Prometheus API endpoint:

| Macro               | Default Value                                              | Description                    |
| ------------------- | ---------------------------------------------------------- | ------------------------------ |
| `{$PROMETHEUS.URL}` | `http://prometheus-server.prometheus.svc.cluster.local:80` | Prometheus server URL endpoint |

### Host Configuration

1. Create a new host or use an existing one
2. Link the "Kubernetes Prometheus Alertmanager" template to the host
3. Update the `{$PROMETHEUS.URL}` macro if your Prometheus endpoint differs from the default

## Monitored Items

### Static Items
- **Prometheus: Alerts** - Raw alert data from Prometheus API
- **Prometheus: Alerts listed** - Processed alert data in JSON format
- **Prometheus: Alerts Status** - Overall API status
- **Prometheus: Watchdog Alert State** - Watchdog alert state monitoring

### Discovery Items (Auto-discovered)
For each discovered alert (excluding Watchdog):
- **Alert Data** - Complete alert information
- **Alert State** - Current state (firing/resolved)
- **Alert Time** - Time when alert became active

## Triggers

### Static Triggers
- **Prometheus Alert Status not Success** (DISASTER) - Triggers when API status is not "success"
- **Prometheus Alert Watchdog not firing** (DISASTER) - Triggers when Watchdog alert is not firing

### Dynamic Triggers (Per Alert)
- **Warning Alerts** (AVERAGE priority) - Triggers for alerts with severity="warning"
- **Critical Alerts** (DISASTER priority) - Triggers for alerts with severity="critical"
- **General Alerts** (WARNING priority) - Triggers for other firing alerts

## Troubleshooting

### Common Issues

1. **No data received**
   - Verify `{$PROMETHEUS.URL}` macro is correct
   - Check network connectivity to Prometheus
   - Ensure Prometheus API is accessible

2. **Discovery not working**
   - Check if Prometheus has active alerts
   - Verify the alerts API returns valid JSON
   - Review Zabbix server logs for preprocessing errors

3. **Triggers not firing**
   - Verify alert data is being collected
   - Check trigger dependencies
   - Ensure alert severity labels match expected values ("warning", "critical")

### Testing

Test the API endpoint manually:
```bash
curl -s "{$PROMETHEUS.URL}/api/v1/alerts" | jq .
```

Expected response structure:
```json
{
    "status": "success",
    "data": {
        "alerts": [
            {
                "labels": { "alertname": "Watchdog", "severity": "none" },
                "annotations": {
                    "description": "...",
                    "runbook_url": "https://runbooks.prometheus-operator.dev/runbooks/general/watchdog",
                    "summary": "An alert that should always be firing to certify that Alertmanager is working properly."
                },
                "state": "firing",
                "activeAt": "2025-03-11T09:08:09.834491859Z",
                "value": "1e+00"
            }
        ]
    }
}

```

## Alert Severity Mapping

| Prometheus Severity | Zabbix Priority | Trigger Type               |
| ------------------- | --------------- | -------------------------- |
| `warning`           | AVERAGE         | Warning severity triggers  |
| `critical`          | DISASTER        | Critical severity triggers |
| Other/None          | WARNING         | General alert triggers     |
