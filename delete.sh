#!/bin/bash
#
# Deletes all TykApis created on your k8s environment.
# 
# Usage: 
#   sh delete.sh

tykapis=$(kubectl get tykapis -A -o json | jq -r '.items[] | {name: .metadata.name, namespace: .metadata.namespace}')
items=$(echo "$tykapis" | jq -c -r '.')

for item in ${items[@]}; do
    name=$(echo $item | jq -r '.name')
    ns=$(echo $item | jq -r '.namespace')
    kubectl delete tykapis $name -n $ns
done
