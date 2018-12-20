# Digmygrafana
A heavily opinionated grafana + sysdig container for auto provisioning dashboards!

## Configuration
The following environment variables are used to configure digmygrafana

```
SYSDIG_TOKEN         | The API token for Sysdig
SYSDIG_URL           | The URL of your Sysdig (Defaults to https://app.sysdigcloud.com)
OAUTH_CLIENT_ID      | The name of the oauth client
OAUTH_CLIENT_SECRET  | The client secret
OAUTH_SCOPE          | The OAuth scope of the user
OAUTH_AUTH_URL       | The oauth auth url
OAUTH_TOKEN_URL      | The oauth token url
OAUTH_API_URL        | The oauth api url
SIGNOUT_REDIRECT_URL | The oauth signout url
JSON_DASHBOARDS      | An array of JSON dashboards
ADMIN_USER           | Defaults to admin
ADMIN_PASSWORD       | Defaults to admin
OAUTH_AUTO_LOGIN     | Defaults to true
```

The `JSON_DASHBOARDS` environment variable looks something like this:

```
[{grafana_dashboard_json},{another_grafana_dashboard_json},{yet_another_grafana_dashboard_json}]
```

## To Build
Run ./build.sh to download and build the docker container
