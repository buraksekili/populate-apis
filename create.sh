#!/bin/bash

#
# Creates a specified number of APIs on the Tyk Dashboard. By default, it creates 5 APIs.
#
# Usage:
#   TYK_AUTH=<AUTH_KEY> TYK_URL=<TYK_URL> MAX=<MAX> ./create.sh

createOasApi() {
  reqBody='{
      "info": {
        "title": "%s",
        "version": "1.0.0"
      },
      "openapi": "3.0.3",
      "components": {},
      "paths": {},
      "x-tyk-api-gateway": {
        "info": {
          "id": "%s",
          "name": "%s",
          "state": {
            "active": true
          }
        },
        "upstream": {
          "url": "https://petstore.swagger.io/v2"
        },
        "server": {
          "listenPath": {
            "value": "/%s",
            "strip": true
          }
        }
      }
    }'

  reqBody=$(printf "$reqBody" "$1" "$1" "$1" "$2")

  echo $reqBody

  curl -sSi -H "Authorization: $TYK_AUTH" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$reqBody" "$TYK_URL"/api/apis/oas


  curl -sSi -H "Authorization: $TYK_AUTH" \
    -H "Content-Type: application/json" \
    -X PUT \
    -d '{ "categories": ["oascategory"]}' "$TYK_URL"/api/apis/oas/"$1"/categories
}

createClassicApi() {
  reqBody='{
        "api_definition": {
            "name": "%s",
            "api_id": "%s",
            "proxy": {
                "target_url": "http://httpbin.org/",
                "listen_path": "/%s/",
                "strip_listen_path": true
            },
            "active": true,
            "disable_rate_limit": true,
            "disable_quota": true,
            "config_data": {
                "k8sName": "%s-k8s"
            },
            "version_data": {
                "not_versioned": true,
                "versions": {
                    "default": {
                        "name": "default"
                    }
                }
            }
        }
    }'
  reqBody=$(printf "$reqBody" "$1" "$3" "$2" "$2")

#  response=$(curl -f -sSi -H "Authorization: $TYK_AUTH" \
#    -H "Content-Type: application/json" \
#    -X POST \
#    -d "$reqBody" $TYK_URL/api/apis)
  response=$(curl -s -H "Authorization: $TYK_AUTH" -X POST -d "$reqBody" "$TYK_URL/api/apis" -w "\n%{http_code}")
  responseCode=$(tail -n1 <<< "$response")

  if [[ $responseCode -ge 200 ]] && [[ $responseCode -lt 300 ]]; then
    echo "API Definition with ID $3 created."
  elif [[ $responseCode -eq 409 ]]; then
    echo "Skip API creation, API Definition with ID $3 already exists."
  else
    echo -e "\t[ERROR] Failed to create API Definition with ID: $3 , responseCode: $responseCode"
  fi
}

createPolicy() {
  reqBody='{
        "rate": 1000,
        "per": 60,
        "quota_max": -1,
        "quota_renews": 1481546970,
        "quota_remaining": 0,
        "quota_renewal_rate": 60,
        "name": "%s",
        "active": true
    }'
  reqBody=$(printf "$reqBody" "$1")

  curl -sSi -H "Authorization: $TYK_AUTH" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$reqBody" $TYK_URL/api/portal/policies/
}

if [[ -z "$MAX" ]]; then
  MAX=5
fi

RANDOM=$$
for i in $(seq 1 $MAX); do
  env="#testing"
  r=$(($RANDOM % 10))
  if [[ $r -gt 5 ]]; then
    env="#production"
  fi

  apiName=$(printf "test-api-%d %s" $i $env)
  listenPath=$(printf "test-api-%d" $i)
  api_id=$(printf "random-id-%d" $i)
  createClassicApi "$apiName" "$listenPath" "$api_id"

  oasApiName=$(printf "test-api-%d" $i)
  createOasApi "$oasApiName" "$listenPath"

  policyName=$(printf "custom-policy-%d" $i)
  createPolicy $policyName
done
