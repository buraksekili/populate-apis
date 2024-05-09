#TYK_AUTH=$(kubectl get secrets -n tyk-operator-system tyk-operator-conf --template={{.data.TYK_AUTH}} | base64 -d)

TYK_AUTH=$TYK_AUTH

deletePolicy() {
    curl -X DELETE -H "Authorization: $TYK_AUTH" $TYK_URL/api/portal/policies/$1
}

deleteAPI() {
    curl -X DELETE -H "Authorization: $TYK_AUTH" $TYK_URL/api/apis/$1
}

APIsJSON=$(curl -sS -H "Authorization: $TYK_AUTH" $TYK_URL/api/apis\?p=-2)
APIIDs=$(echo $APIsJSON| jq -r '.apis[].api_definition | .id')

for id in $APIIDs
do
    deleteAPI $id
done


policiesJSON=$(curl -sS -H "Authorization: $TYK_AUTH" $TYK_URL/api/portal/policies\?p=-2 2>&1)
polIDs=$(echo $policiesJSON | jq -r '.Data[] | ._id')


for id in $polIDs
do
    deletePolicy $id
done
