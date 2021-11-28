# Examples

This folder contains example Argo CD manifests to automate continuous delivery tasks from a Git repository and manage the cluster using GitOps principles.

## Using GitHub

Either use or fork the <https://github.com/kevinobee/k8s-gitops> Git repository to define an Argo CD _App of Apps_that will bootstrap the cluster.

Run the following command to configure Argo CD to use the public [k8s-gitops](https://github.com/kevinobee/k8s-gitops) GitHub repository

```Shell
kubectl -n argocd apply -f ./examples/github-gitops-argocd-app.yaml
```

*Note:* If you have forked the repository ensure that you update the source `repoUrl` setting in the yaml file before applying it.

## Using Gitea

To run Argo CD pipelines in the Kubernetes hosted Gitea do the following steps:

1. Start the local development cluster containing Argo CD

1. Login to Gitea at <http://git.example.com> and create an empty `k8s-gitops` repository

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
