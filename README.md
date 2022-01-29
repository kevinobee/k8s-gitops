# GitOps with Kubernetes using Argo CD & Kustomize

Repository contains YAML manifests to bootstrap a Kubernetes cluster maintained by [Argo CD](https://argoproj.github.io/cd/).

## Pre-requisites

* [Kubernetes cluster](https://kubernetes.io/)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

### Simple Cluster Setup

The [Kind](https://kind.sigs.k8s.io/) tool offers a simple way of creating a local Kubernetes cluster with only a single dependency on Docker.

Create a cluster using the following commands:

```shell
# download the kind cli and move to /usr/local/bin/
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/

# create the kubernetes cluster
kind create cluster
```

## Getting Started

Bootstrap the cluster using the command:

```Shell
kustomize build apps | kubectl apply -f -
```

## Cluster Applications

* Kubernetes dashboard

  <https://k8s.example.com/>

  Get the admin access token:

  ```shell
  export TOKEN_NAME=$(kubectl get secret -n kubernetes-dashboard -o name | grep dashboard-admin-sa-token)

  export TOKEN=$(kubectl get $TOKEN_NAME -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 -d && echo)

  echo $TOKEN
  ```

* Argo CD

  <https://argocd.example.com/>

  Get the admin users password:

  ```shell
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
  ```

* Gatekeeper UI

  <https://gatekeeper.example.com/>

* Monitoring UI

  <https://loki.example.com>

  Loki monitoring stack contains Promtail, Grafana and Prometheus

  Get the admin users password:

  ```shell
  kubectl get secret --namespace monitoring loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
  ```

* SPEKT8 Cluster Visualization

  <https://spekt8.example.com/>

* Gitea

  <https://git.example.com>

  Login as the `gitea` user with the password `gitea`

## Build Automation

Refer to the [manifest-scans](https://github.com/kevinobee/k8s-gitops/actions/workflows/manifest-scans.yml) GitHub Action

## References

* [Deploying Kubernetes Dashboard with Argo/Kustomize](https://www.frakkingsweet.com/deploying-kubernetes-dashboard-with-argo-kustomize/) blog post

* [Argo CD](https://argoproj.github.io/cd/) declarative, GitOps continuous delivery tool for Kubernetes.

* [Loki](https://grafana.com/oss/loki/) monitoring stack.

### Security and Configuration

* [Kubescape](https://hub.armo.cloud/docs)

* [Datree](https://www.datree.io/)

* [Gatekeeper UI](https://github.com/krackjack29/gatekeeper-ui)

  A simple web interface to view the constraints, violations and templates of Gatekeeper (Open Policy Agent) policies deployed in the cluster.

### Dashboards and Visualizations

* [SPEKT8](https://github.com/spekt8/spekt8)

  SPEKT8 is a new visualization tool for your Kubernetes clusters. It automatically builds logical topologies of your application and infrastructure, which enable your SRE and Ops team to intuitively understand, monitor, and control your containerized, micro services based application.

### Developer Applications

* [Gitea](https://gitea.com/)

