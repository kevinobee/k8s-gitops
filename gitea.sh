#!/bin/bash

export BASE_HOST=$(kubectl get nodes -o jsonpath='{.items[].status.addresses[].address}')
export GITEA_HOST="http://$BASE_HOST:32322"

printf "\nGitea: ${GITEA_HOST}\n"
