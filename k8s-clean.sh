#!/bin/bash
#
# Deletes all TykApis created on your k8s environment.
# 
# Usage: 
#   sh delete.sh

tykapis=$(kubectl get tykapis -A -o json | jq -r '.items[] | {name: .metadata.name, namespace: .metadata.namespace}')
apis=$(echo "$tykapis" | jq -c -r '.')

for api in ${apis[@]}; do
    name=$(echo $api | jq -r '.name')
    ns=$(echo $api | jq -r '.namespace')
    kubectl delete tykapis $name -n $ns
done


securityPolicies=$(kubectl get securitypolicies -A -o json | jq -r '.items[] | {name: .metadata.name, namespace: .metadata.namespace}')
policies=$(echo "$securityPolicies" | jq -c -r '.')

for policy in ${policies[@]}; do
    name=$(echo $policy | jq -r '.name')
    ns=$(echo $policy | jq -r '.namespace')
    kubectl delete securitypolicies $name -n $ns
done
