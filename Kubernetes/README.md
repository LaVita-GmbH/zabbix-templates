# Kubernetes cluster state by HTTP with Prometheus

## Description
This Template extends the [Kubernetes cluster state by HTTP](https://git.zabbix.com/projects/ZBX/repos/zabbix/browse/templates/app/kubernetes_http/kubernetes_state_http/README.md) from the [Zabbix Kubernetes Template](https://www.zabbix.com/integrations/kubernetes) using a Prometheus API.

## Features
- PVC:
  - Monitoring of PVC Usage with triggers at >90%, >95% and >99%
  - Triggers if count of PVCs decrease
- CPU:
  - Monitoring of CPU Usage and Percentage of requests and limits
  - Triggers if CPU Usage is close to the limit
  - Triggers if CPU Usage is far away from the request
- Memory:
  - Monitoring of Memory Usage and Percentage of requests and limits
  - Triggers if Memory Usage is close to the limit
  - Triggers if Memory Usage is far away from the request

## Requirements
- Kubernetes cluster with Prometheus Server  
  Tested with [Prometheus Helm Chart](https://prometheus-community.github.io/helm-charts) Version 23.1.0
- [Template Kubernetes cluster state by HTTP](https://www.zabbix.com/integrations/kubernetes)

## Installation
1. install a Prometheus Server with the [Prometheus Helm Chart](https://prometheus-community.github.io/helm-charts) (if you don't have one already)  
  For CPU monitoring you need to add the contents of alerting-rules.yaml to `serverFiles.alerting_rules.yml` in the values.yaml of the helm chart.
2. Follow the [Zabbix Kubernetes Template](https://www.zabbix.com/integrations/kubernetes) installation instructions
3. Import the template `kubernetes_state_prometheus.xml` into Zabbix
4. _Switch_ the template `Template App Kubernetes State by HTTP` to `Template App Kubernetes State by HTTP with Prometheus` on the Dummy Server
5. Set the Macro `{$PROMETHEUS.URL}` to the URL of your Prometheus Server if needed.
  The default value is `http://prometheus-server.prometheus.svc.cluster.local:80` and assumes a default helm installation running in a namespace called `prometheus`.
