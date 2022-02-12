#!/bin/bash
# test-apps.sh - checks cluster applications are accessible using ingress

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;

echo
kubectl get ingress -A && echo

LB_IP="172.18.0.200"

apps=( \
  "argocd" \
  "gpm" \
  "k8s" \
  "loki"
)

for i in "${apps[@]}"
do
  echo "Check ingress for ${i} ... "

  # host="${i}.example.com"
  # curl -L -D- http://${LB_IP} -H 'Host: ${host}'

  #  STATUS=$(curl -s -A $i -o /dev/null -w '%{http_code}' "http://localhost/")
  #  if [ $STATUS -ne 444 ] && [ $STATUS -ne 000 ]; then
  #     echo "*** Failed, allowed access to domain for User Agent $i (Status Code: $STATUS)"
  #     exit 1
  #  fi
done

# # wait for deployments
# kubectl get deployment -A -w
# curl -L -D- http://172.18.0.200 -H 'Host: argocd.example.com'
# curl -D- https://172.18.0.200 -H 'Host: k8s.example.com' -s -v


