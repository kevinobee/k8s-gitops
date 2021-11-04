# k8s-gitops

Repository contains Kubernetes manifests to define a cluster maintained by Argo CD.

## Getting Started

Either use or fork the <https://github.com/kevinobee/k8s-gitops> Git repository and then create an Argo CD application to manage the cluster using GitOps principles.

```Shell
kubectl -n argocd apply -f ./examples/github-gitops-argocd-app.yaml
```

If you have forked the repository ensure that you update the source `repoUrl` setting in the yaml file before applying it.

### Using Gitea

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

1. Push the code to Gitea from this folder

    ```Shell
    git push -u origin main
    ```

1. Create the Argo CD application that will bootstrap the cluster

  Ensure that the source `repoUrl` setting in the yaml file contains your `BASE_HOST` address and then run the following:

  ```Shell
  kubectl -n argocd apply -f ./examples/gitea-gitops-argocd-app.yaml
  ```
