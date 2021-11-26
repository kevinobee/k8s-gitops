# k8s-gitops

Repository contains Kubernetes manifests to define a cluster maintained by Argo CD.

## Getting Started

Either use or fork the <https://github.com/kevinobee/k8s-gitops> Git repository and then create an Argo CD application to manage the cluster using GitOps principles.

```Shell
kubectl -n argocd apply -f ./examples/github-gitops-argocd-app.yaml
```

*Note:* If you have forked the repository ensure that you update the source `repoUrl` setting in the yaml file before applying it.

### Using Gitea

1. Start the local development cluster and then run the `./gitea.sh` script to view the url where Gitea can be accessed locally.

    Running the `./gitea.sh` script will setup the `BASE_HOST` and `GITEA_HOST` environment variables used in the following steps.

1. Login to Gitea and create an empty `k8s-gitops` repository

1. Push the repository code to Gitea in the cluster

    ```Shell
    git remote add gitea http://git.example.com/gitea_admin/k8s-gitops.git
    git push -u gitea main
    ```

1. Create the Argo CD application that will bootstrap the cluster

    Ensure that the source `repoUrl` setting in the yaml file contains your `BASE_HOST` address and then run the following command:

    ```Shell
    kubectl -n argocd apply -f ./examples/gitea-gitops-argocd-app.yaml
    ```
