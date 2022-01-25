# GitOps with Kubernetes using Argo CD & Kustomize

Repository contains Kubernetes manifests to bootstrap a Kubernetes cluster maintained by [Argo CD](https://argoproj.github.io/cd/).

## Pre-requisites

* [Kubernetes](https://kubernetes.io/)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

You will need a Kubernetes cluster containing Argo CD to host the manifests contained within this repository. Refer to <https://github.com/kevinobee/k8s-dev-cluster> for Terraform scripts that automate this setup step.

## Getting Started

Either use or fork the <https://github.com/kevinobee/k8s-gitops> Git repository and then create an Argo CD application to manage the cluster using GitOps principles.

Run the following command to create an Argo CD _App of Apps_that will bootstrap the cluster:

```Shell
kubectl -n argocd apply -f ./examples/github-gitops-argocd-app.yaml
```

*Note:* If you have forked the repository ensure that you update the source `repoUrl` setting in the yaml file before applying it.

## Cluster Applications

* Kubernetes dashboard

  <https://kubedashboard.example.com/>

  Get the access token:

  ```shell
  export TOKEN_NAME=$(kubectl get secret -n kubernetes-dashboard -o name | grep dashboard-admin-sa-token)

  export TOKEN=$(kubectl get $TOKEN_NAME -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 -d && echo)

  echo $TOKEN
  ```

* [Argo CD](https://argoproj.github.io/cd/) declarative, GitOps continuous delivery tool for Kubernetes

  <https://argocd.example.com/>

  Get the Admin users password:

  ```shell
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
  ```

* Gatekeeper UI

  <https://gatekeeper.example.com/>

* [Loki](https://grafana.com/oss/loki/) stack (Loki, Promtail, Grafana, Prometheus)

    <http://loki.example.com>

* [Gitea](https://gitea.com/) self-hosted Git service

    <http://git.example.com>

    See the [examples documentation](./examples/README.md) for instructions on how to setup GitOps using the cluster hosted Gitea service

<!--
* [Heimdall](https://heimdall.site/) application dashboard and launcher

    <http://apps.example.com> -->

## Best Practices

1. Code Policy Enforcement

    [Datree](https://www.datree.io/) prevents Kubernetes misconfiguration issues From reaching production.

    [Datree GitHub Action](https://github.com/kevinobee/k8s-gitops/actions/workflows/datree-master-commit-analysis.yml)

1. Security

    NSA framework analysis rules are run by [Kubescape](https://hub.armo.cloud/docs)

    [Kubescape GitHub Action](https://github.com/kevinobee/k8s-gitops/actions/workflows/kubescape-master-commit-analysis.yaml)

## References

* [Deploying Kubernetes Dashboard with Argo/Kustomize](https://www.frakkingsweet.com/deploying-kubernetes-dashboard-with-argo-kustomize/) blog post

* [Gatekeeper UI](https://github.com/krackjack29/gatekeeper-ui)

  A simple web interface to view the constraints, violations and templates of Gatekeeper (Open policy agent) policies deployed in the cluster.
