# k8s-gitops

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

* [Argo CD](https://argoproj.github.io/cd/) declarative, GitOps continuous delivery tool for Kubernetes

     <http://argocd.example.com>

* [Gitea](https://gitea.com/) self-hosted Git service

    <http://git.example.com>

    See the [examples documentation](./examples/README.md) for instructions on how to setup GitOps using the cluster hosted Gitea service

* [Heimdall](https://heimdall.site/) application dashboard and launcher

    <http://apps.example.com>

* [Loki](https://grafana.com/oss/loki/) stack (Loki, Promtail, Grafana, Prometheus)

    <http://loki.example.com>

## Best Practices

1. Security

    NSA framework analysis rules are run by [Kubescape](https://hub.armo.cloud/docs) as part of CI/CD on [GitHub](https://github.com/kevinobee/k8s-gitops/actions)
