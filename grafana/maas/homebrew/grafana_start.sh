#!/bin/bash
cd /usr/share/grafana.maas
grafana-server -config /etc/grafana.maas/grafana.ini cfg:default.paths.data=/var/lib/grafana.maas 1>/var/log/grafana.maas.log 2>&1
