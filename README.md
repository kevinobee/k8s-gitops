# k8s-gitops

Repository contains Kubernetes manifests to define a cluster maintained by Argo CD.

## Getting Started

1. Start Gitea in Kubernetes

    Start the local development cluster and then run the following commands:

    ```Shell
    export BASE_HOST=$(kubectl get nodes -o jsonpath='{.items[].status.addresses[].address}')
    export GITEA_HOST="http://$BASE_HOST:32322"

    printf "Services:\n\n"
    printf "Gitea: ${GITEA_HOST}\n"

    git remote add origin http://$GITEA_HOST:32322/gitea_admin/k8s-gitops.git
    ```

1. Create a `k8s-gitops` repository in Gitea

1. Push the code to Gitea

    ```Shell
    git push --set-upstream origin main
    ```
