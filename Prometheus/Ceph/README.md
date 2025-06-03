# Ceph Prometheus Discovery

## Description

This Zabbix template monitors Ceph storage clusters using Prometheus metrics. It provides comprehensive monitoring of cluster health, storage pools, and overall cluster statistics through Prometheus data collection.

## Features

- **Cluster Monitoring:**
  - Total cluster size and used space
  - Overall storage usage percentage with trigger at >85%
  - Cluster health status monitoring

- **Health Monitoring:**
  - Automatic discovery of Ceph health details
  - Critical and warning health status triggers
  - Health state monitoring for specific components

- **Pool Discovery and Monitoring:**
  - Automatic discovery of all Ceph pools
  - Per-pool storage usage with multiple threshold triggers:
    - Warning: <20% free space remaining
    - Average: <15% free space remaining  
    - High: <10% free space remaining
    - Disaster: <6% free space remaining
  - Pool statistics: objects, dirty data, quotas
  - Read/write operations monitoring
  - Recovery operations tracking
  - Placement group (PG) status monitoring

- **Visual Dashboards:**
  - Pie chart showing overall storage usage

## Requirements

- **Ceph Cluster:** A running Ceph cluster with Prometheus metrics enabled
- **Prometheus Metrics Endpoint:** Ceph must be configured to expose Prometheus metrics
- **Network Access:** Zabbix server/proxy must be able to access the Prometheus metrics endpoint

## Installation

1. **Configure Ceph Prometheus Metrics:**
   - Ensure your Ceph cluster has the Prometheus module enabled:
     ```bash
     ceph mgr module enable prometheus
     ```
   - Verify metrics are accessible at your Prometheus endpoint

2. **Import the Template:**
   - Import the `zbx_templates_ceph_prometheus.yaml` file into your Zabbix instance (Configuration > Templates > Import)

3. **Create a Host:**
   - Create a new host in Zabbix for your Ceph cluster
   - Link the "Ceph Prometheus Discovery" template to this host

4. **Configure Macros:**
   - Set the `{$METRICS_URL}` macro to your Ceph Prometheus metrics endpoint
   - Default value: `http://server.local/metrics`
   - Example: `http://ceph-mgr.example.com:9283/metrics`

## Macros

- `{$METRICS_URL}`: The URL endpoint where Ceph Prometheus metrics are exposed (Default: `http://server.local/metrics`)

## Monitored Metrics

The template collects and processes the following Prometheus metrics:
- `ceph_cluster_total_bytes` - Total cluster capacity
- `ceph_cluster_total_used_bytes` - Used cluster space
- `ceph_health_status` - Overall cluster health
- `ceph_health_detail` - Detailed health information
- `ceph_pool_*` - Various pool-specific metrics
- `ceph_pg_*` - Placement group metrics

## Notes

- The template uses HTTP agent items to collect Prometheus metrics every 15 seconds
- All dependent items are processed from the main Prometheus data collection
- Discovery rules automatically find and monitor new pools and health details
- Triggers include dependencies to prevent alert storms during cluster issues
