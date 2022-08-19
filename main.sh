createApi() {
    reqBody='{
        "api_definition": {
            "name": "%s",
            "proxy": {
                "target_url": "http://httpbin.org/",
                "listen_path": "/httpbin/",
                "strip_listen_path": true
            },
            "use_keyless": true,
            "active": true,
            "disable_rate_limit": true,
            "disable_quota": true,
            "version_data": {
                "not_versioned": true,
                "versions": {
                    "Default": {
                        "name": "Default"
                    }
                }
            }
        }
    }'
    reqBody=$(printf "$reqBody" "$1")
    
    curl -sSi -H "Authorization: $TYK_AUTH" \
    -s \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$reqBody" http://localhost:3000/api/apis
}

MAX=5
for i in `seq 1 $MAX`
do
    apiName=$(printf "test-api-%d" $i)
    createApi $apiName
done