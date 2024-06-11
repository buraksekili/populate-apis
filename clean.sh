deletePolicy() {
  if [[ -z $TYK_GATEWAY ]]; then
    curl -X DELETE -H "Authorization: $TYK_AUTH" $TYK_URL/api/portal/policies/$1
  else
    curl -sSi -H "x-tyk-authorization: $TYK_AUTH" -X DELETE $TYK_URL/tyk/policies/$1
    reloadGateway
  fi
}

deleteAPI() {
    if [[ -z $TYK_GATEWAY ]]; then
      curl -X DELETE -H "Authorization: $TYK_AUTH" $TYK_URL/api/apis/$1
    else
      curl -sSi -H "x-tyk-authorization: $TYK_AUTH" -X DELETE $TYK_URL/tyk/apis/$1
      reloadGateway
    fi
}

reloadGateway() {
  curl -s -H "x-tyk-authorization: $TYK_AUTH" "$TYK_URL/tyk/reload/group"
}


if [[ -z $TYK_GATEWAY ]]; then
  APIsJSON=$(curl -sS -H "Authorization: $TYK_AUTH" $TYK_URL/api/apis\?p=-2)
  APIIDs=$(echo $APIsJSON| jq -r '.apis[].api_definition | .id')
else
  APIsJSON=$(curl -sS -H "x-tyk-authorization: $TYK_AUTH" $TYK_URL/tyk/apis\?p=-2)
  APIIDs=$(echo $APIsJSON| jq -r '.[] | .api_id')
fi

for id in $APIIDs
do
    echo "=> $id"
    deleteAPI "$id"
done


if [[ -z $TYK_GATEWAY ]]; then
  policiesJSON=$(curl -sS -H "Authorization: $TYK_AUTH" $TYK_URL/api/portal/policies\?p=-2 2>&1)
  polIDs=$(echo $policiesJSON | jq -r '.Data[] | ._id')
else
  policiesJSON=$(curl -sS -H "x-tyk-authorization: $TYK_AUTH" $TYK_URL/tyk/policies\?p=-2 2>&1)
  polIDs=$(echo $policiesJSON | jq -r '.[] | ._id')
fi


for id in $polIDs
do
    deletePolicy $id
done
