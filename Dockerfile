FROM grafana/grafana:6.4.4
USER root
RUN apk update \
 && apk add jq \
 && rm -rf /var/cache/apk/*
RUN chown -R grafana:grafana /etc/grafana
USER grafana
ADD sysdig /var/lib/grafana/plugins/sysdig
ADD provisioning /etc/grafana/provisioning
ADD setup_and_run.sh /setup_and_run.sh


ENTRYPOINT [ "/setup_and_run.sh"]
