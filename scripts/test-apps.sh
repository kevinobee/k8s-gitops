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
  "k8s"
)

for i in "${apps[@]}"
do
  host="${i}.example.com"
  url="https://${host}"

  echo "Check ingress for ${url} ... "

  STATUS=$(curl --insecure -s -o /dev/null -w '%{http_code}' ${url})
  if [ $STATUS -ne 444 ] && [ $STATUS -ne 200 ]; then
    echo "*** Failed, access to ${url} (Status Code: $STATUS)"
    exit 1
  fi
done
