#!/bin/bash
# /usr/lib/zabbix/externalscripts/certcheck.sh
# Monitoring SSL Certificate Expiry Using Zabbix

data=`echo | openssl s_client -host $1 -port $2 -showcerts -prexit </dev/null 2>/dev/null | openssl x509 -noout -enddate | sed -e 's#notAfter=##'`

echo `date -d "${data}" +%s`
