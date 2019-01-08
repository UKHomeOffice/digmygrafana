FROM grafana/grafana:5.4.2
USER root
RUN apt-get update -qq && apt-get upgrade -y -qq && apt-get install -qq -y jq
RUN chown -R grafana:grafana /etc/grafana
USER grafana
ADD sysdig /var/lib/grafana/plugins/sysdig
ADD provisioning /etc/grafana/provisioning
ADD setup_and_run.sh /setup_and_run.sh


ENTRYPOINT [ "/setup_and_run.sh"]
