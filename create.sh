#!/bin/bash
#
# Creates a specified number of APIs on the Tyk Dashboard. By default, it creates 5 APIs.
# 
# Usage: 
#   TYK_AUTH=<AUTH_KEY> MAX=<MAX> sh create.sh

createApi() {
    reqBody='{
        "api_definition": {
            "name": "%s",
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
    reqBody=$(printf "$reqBody" "$1" "$2" "$2")

    
    curl -sSi -H "Authorization: $TYK_AUTH" \
        -H "Content-Type: application/json" \
        -X POST \
        -d "$reqBody" $TYK_URL/api/apis
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

if [[ -z "$MAX" ]]
then
    MAX=5
fi


RANDOM=$$
for i in `seq 1 $MAX`
do
    env="#testing"
    r=$(($RANDOM%10))
    if [[ $r -gt 5 ]]
    then
	    env="#production"
    fi

    apiName=$(printf "test-api-%d %s" $i $env)
    listenPath=$(printf "test-api-%d" $i)
    createApi "$apiName" "$listenPath"

    policyName=$(printf "custom-policy-%d" $i)
    createPolicy $policyName
done
