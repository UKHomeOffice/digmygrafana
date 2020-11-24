FROM grafana/grafana:6.6.2

USER root

RUN apk update \
 && apk add jq curl tar \
 && rm -rf /var/cache/apk/*

# curl https://download.sysdig.com/stable/grafana-sysdig-datasource/grafana-sysdig-datasource-v0.7.tgz -o sysdig.tgz
# tar zxf sysdig.tgz -C .

RUN chown -R grafana:grafana /etc/grafana

USER grafana

ADD sysdig /var/lib/grafana/plugins/sysdig
ADD provisioning /etc/grafana/provisioning
ADD setup_and_run.sh /setup_and_run.sh

ENTRYPOINT [ "/setup_and_run.sh"]
