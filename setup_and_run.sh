#!/bin/sh

### This is where grafana provisions dashboards in the container
mkdir /var/lib/grafana/dashboards
cd /var/lib/grafana/dashboards

####### BUILD THE DASHBOARDS #######
echo $JSON_DASHBOARDS | jq .[] -c > dashboards
cat dashboards | while read line
do
  count=$((count + 1))
  echo $line > "dashboard_$count.json"
done

rm dashboards

cd /usr/share/grafana

### Set up grafana.ini ###
cat << EOL > "/etc/grafana/grafana.ini"
[auth]
# URL to redirect the user to after sign out
signout_redirect_url = ${SIGNOUT_REDIRECT_URL}

# Set to true to attempt login with OAuth automatically, skipping the login screen.
# This setting is ignored if multiple OAuth providers are configured.
oauth_auto_login = true

#################################### Generic OAuth ##########################
[auth.generic_oauth]
enabled = true
name = OAuth
;allow_sign_up = true
client_id = ${OAUTH_CLIENT_ID}
client_secret = ${OAUTH_CLIENT_SECRET}
scopes = ${OAUTH_SCOPE}
auth_url = ${OAUTH_AUTH_URL}
token_url = ${OAUTH_TOKEN_URL}
api_url = ${OAUTH_API_URL}

EOL


### Set up sysdig plugin ###
cat << EOL > "/etc/grafana/provisioning/datasources/sysdig.yml"
apiVersion: 1
datasources:
- name: Sysdig
  type: sysdig
  access: proxy
  orgId: 1
  # <string> Sysdig URL (Basic/Pro Cloud will use https://app.sysdigcloud.com, Pro Software will refer to your Sysdig deployment)
  url: ${SYSDIG_URL}
  basicAuth: false
  withCredentials: false
  # <bool> mark as default datasource. Max one per org
  isDefault: false
  # <map> fields that will be converted to json and stored in jsonData
  # apiToken must be set to the API token associated to your user and team
  jsonData:
     apiToken: ${SYSDIG_TOKEN}
     tlsAuth: false
     tlsAuthWithCACert: false
  version: 1
  # <bool> allow users to edit datasources from the UI.
  editable: false

EOL


# Run grafana
sh /run.sh
