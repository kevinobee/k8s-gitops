#!/bin/bash
# add-host-entries.sh - adds entries to /etc/hosts for ingress domains

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;
