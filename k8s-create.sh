#!/bin/bash
#
# Creates a specified number of ApiDefinition CRs on the k8s state. By default, it creates 5 CRs.
# 
# Usage: 
#   ./k8s-create.sh

createApiDefinitionCR() {
    reqBody='
apiVersion: tyk.tyk.io/v1alpha1
kind: ApiDefinition
metadata:
  name: apidef-%s-test
spec:
  name: httpbin %s
  use_keyless: true
  protocol: http
  active: true
  do_not_track: false
  proxy:
    target_url: http://httpbin.org/
    listen_path: /httpbin-test%s
    strip_listen_path: true
  version_data:
    default_version: Default
    not_versioned: true
    versions:
      Default:
        name: Default
'
    reqBody=$(printf "$reqBody" "$1" "$1" "$1")


    cat <<EOF | kubectl apply -f -             
    $(printf "%s" "$reqBody")
EOF
}

if [[ -z "$MAX" ]]
then
    MAX=5
fi


for i in `seq 1 $MAX`
do
    createApiDefinitionCR "$i"
done
