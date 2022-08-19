deletePolicy() {
    curl -X DELETE -H "Authorization: $TYK_AUTH" localhost:3000/api/portal/policies/$1
}

deleteAPI() {
    curl -X DELETE -H "Authorization: $TYK_AUTH" localhost:3000/api/apis/$1
}

APIsJSON=$(curl -sS -H "Authorization: $TYK_AUTH" http://localhost:3000/api/apis\?p=-2)
APIIDs=$(echo $APIsJSON| jq -r '.apis[].api_definition | .id')

for id in $APIIDs
do
    deleteAPI $id
done


policiesJSON=$(curl -sS -H "Authorization: $TYK_AUTH" http://localhost:3000/api/portal/policies\?p=-2 2>&1)
polIDs=$(echo $policiesJSON | jq -r '.Data[] | ._id')


for id in $polIDs
do
    deletePolicy $id
    i=$((i+1))
done