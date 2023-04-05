#!/bin/bash
#
# Deletes all ApiDefinition and SecurityPolicy CRscreated on your k8s environment.
# Alternatively, it can delete namespaces starting with given prefix.
# 
# Usage: 
#   sh k8s-clean.sh

# First delete all policies.
securityPolicies=$(kubectl get securitypolicies -A -o json | jq -r '.items[] | {name: .metadata.name, namespace: .metadata.namespace}')
policies=$(echo "$securityPolicies" | jq -c -r '.')

for policy in ${policies[@]}; do
    name=$(echo $policy | jq -r '.name')
    ns=$(echo $policy | jq -r '.namespace')
    kubectl delete securitypolicies $name -n $ns
done

# Then delete ApiDefinition
tykapis=$(kubectl get tykapis -A -o json | jq -r '.items[] | {name: .metadata.name, namespace: .metadata.namespace}')
apis=$(echo "$tykapis" | jq -c -r '.')

for api in ${apis[@]}; do
    name=$(echo $api | jq -r '.name')
    ns=$(echo $api | jq -r '.namespace')
    kubectl delete tykapis $name -n $ns
done

# Delete all OperatorContext CRs
operatorcontexts=$(kubectl get operatorcontexts -A -o json | jq -r '.items[] | {name: .metadata.name, namespace: .metadata.namespace}')
opCtxs=$(echo "$operatorcontexts" | jq -c -r '.')

for opCtx in ${opCtxs[@]}; do
    name=$(echo $opCtx | jq -r '.name')
    ns=$(echo $opCtx | jq -r '.namespace')
    kubectl delete operatorcontext $name -n $ns &
    kubectl patch operatorcontext $name -n $ns -p '{"metadata":{"finalizers":null}}' --type=merge
done

nsOutput=$(kubectl get ns -o json | jq -r '.items[] | {name: .metadata.name}')
namespaces=$(echo "$nsOutput" | jq -c -r '.')

NSPREFIX="tyk-operator-"
if [[ -n $NS ]]
then
	NSPREFIX=$NS 
fi

echo "looking for ${NSPREFIX}"

for namespace in ${namespaces[@]}; do
    ns=$(echo $namespace | jq -r '.name')
    if [[ $ns != tyk-operator-system ]] && [[ $ns =~ tyk-operator-* ]]
    then
	kubectl delete ns $ns &
    fi
done

