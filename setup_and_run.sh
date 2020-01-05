#!/bin/bash

### This is where grafana provisions dashboards in the container
mkdir /var/lib/grafana/dashboards
cd /var/lib/grafana/dashboards

####### BUILD THE DASHBOARDS #######
echo $JSON_DASHBOARDS | jq .[] -c > dashboards
cat dashboards | while read -r line
do
  count=$((count + 1))
  echo $line > "dashboard_$count.json"
done

rm dashboards

cd /usr/share/grafana

OAUTH_AUTO_LOGIN="${OAUTH_AUTO_LOGIN:-true}"
SYSDIG_URL="${SYSDIG_URL:-https://app.sysdigcloud.com}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin}"

if [ "${ADMIN_PASSWORD}" == "admin" ]; then
  echo "Warning!!! You are running a continer with the admin password as admin! Don't do this in production!!!!!"
fi

### Set up grafana.ini ###
cat << EOL > "/etc/grafana/grafana.ini"
[auth]
# URL to redirect the user to after sign out
signout_redirect_url = ${SIGNOUT_REDIRECT_URL}

# Set to true to attempt login with OAuth automatically, skipping the login screen.
# This setting is ignored if multiple OAuth providers are configured.
oauth_auto_login = ${OAUTH_AUTO_LOGIN}

#################################### Security ############################
[security]
# default admin user, created on startup
admin_user = ${ADMIN_USER}

# default admin password, can be changed before first start of grafana, or in profile settings
admin_password = ${ADMIN_PASSWORD}

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

if [[ -n "${POSTGRES_HOST}" ]]; then
cat << EOL >> "/etc/grafana/provisioning/datasources/postgres.yml"
apiVersion: 1
datasources:
- name: Postgres
  type: postgres
  access: proxy
  url: ${POSTGRES_HOST}:5432
  secureJsonData:
    password: ${POSTGRES_PASS}
  user: ${POSTGRES_USER}
  database: ${POSTGRES_DB_NAME}
  basicAuth: false
  isDefault: false
  jsonData:
    sslmode: disable
  version: 1
  editable: false

EOL
fi


# Run grafana
sh /run.sh
