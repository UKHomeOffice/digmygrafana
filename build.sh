#!/bin/sh

curl https://download.sysdig.com/stable/grafana-sysdig-datasource/grafana-sysdig-datasource-v0.7.tgz -o sysdig.tgz

tar zxf sysdig.tgz -C .

docker build -t digmygrafana .
