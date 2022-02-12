#!/bin/bash
# test-apps.sh - checks cluster applications are accessible using ingress

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;

LB_IP="172.18.0.200"

apps=( \
  "argocd" \
  "gpm" \
  "k8s" 
  # "loki"
)

for i in "${apps[@]}"
do
  echo "Check ingress for ${i} ... "

  host="${i}.example.com"
  url="https://${host}"

  STATUS=$(curl --insecure -s -o /dev/null -w '%{http_code}' ${url})
  if [ $STATUS -ne 444 ] && [ $STATUS -ne 200 ]; then
    echo "*** Failed, allowed access to domain for User Agent $i (Status Code: $STATUS)"
    exit 1
  fi
done


