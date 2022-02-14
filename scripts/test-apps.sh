#!/bin/bash
# test-apps.sh - checks cluster applications are accessible using ingress

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

apps=( \
  "argocd" \
  "gpm" \
  "k8s" \
  "loki"
)

LB_IP=$(kubectl get svc/ingress-nginx-controller -n ingress-nginx -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
LB_URL="https://${LB_IP}"

for i in "${apps[@]}"
do
  HOST="${i}.example.com"

  echo "Check ${HOST} ... "

  STATUS=$(curl -L -H "Host: ${HOST}" --insecure -s -o /dev/null -w '%{http_code}' ${LB_URL})
  if [ $STATUS -ne 444 ] && [ $STATUS -ne 200 ]; then
    echo "*** Failed, access to Host: ${HOST} at ${LB_URL} (Status Code: $STATUS)"
    exit 1
  fi
done
