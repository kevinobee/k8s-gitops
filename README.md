# GitOps with Kubernetes using Argo CD & Kustomize

Repository contains YAML manifests to bootstrap a Kubernetes cluster maintained by [Argo CD](https://argoproj.github.io/cd/).

## Getting Started

To install the Kubernetes cluster and applications for GitOps, run:

```shell
git clone https://github.com/kevinobee/k8s-gitops.git
cd k8s-gitops
./install.sh
```

The installation script uses the [Kind](https://kind.sigs.k8s.io/) tool, which offers a simple way of creating a local Kubernetes cluster with only a single dependency on Docker.

Your cluster and applications are now running, time to start developing.

## Argo CD

The `install.sh` script creates the core applications in the cluster required for GitOps, primarily Argo CD.

The Argo CD UI can be accessed by loading <https://localhost:8080/> in a browser.

The `admin` users password is stored in `ARGOCD_PWD` environment variable by the `install.sh` script. Alternatively view the password by running the following commands:

```shell
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
echo ${ARGOCD_PWD}
```

## GitOps

The `install.sh` script will create a `gitops` application in Argo CD following the [App of Apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps) pattern.

After Argo CD has synced the applications the following services will be exposed via a load balancer and ingress:

* Gatekeeper Policy Manager (GPM)

  <https://gpm.local/>

* Monitoring UI

  <https://loki.local>

  Loki monitoring stack contains Promtail, Grafana and Prometheus

  Admin users password stored in `LOKI_PWD` environment variable.

  ```shell
  export LOKI_PWD=$(kubectl get secret --namespace monitoring loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
  echo ${LOKI_PWD}
  ```

### Host Names

Setup entries for `.local` domain names in your `/etc/hosts` file by running the following commands after the `install.sh` script has completed:

```shell
LB_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo "${LB_IP} gpm.local litmus.local loki.local" | sudo tee -a /etc/hosts
```

## CLI Tooling

The `install.sh` script will add a few useful tools to your environment for working with the Kubernetes cluster. The script itself makes use of [argocd](https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd/) and [linkerd](https://linkerd.io/2.10/reference/cli/) CLI tooling. Other tools are detailed below:

1. [Octant](https://octant.dev/) is an open source developer-centric web interface for Kubernetes that lets you inspect a Kubernetes cluster and its applications.

    To open the Octant web interface run the command:

    ```shell
    octant
    ```

    The Octant dashboard will be available at <http://127.0.0.1:7777/>

## Build Automation

Refer to the [Static Analysis](https://github.com/kevinobee/k8s-gitops/actions/workflows/static-analysis.yml) action and [Code scanning alerts](https://github.com/kevinobee/k8s-gitops/security/code-scanning) on GitHub for security and configuration scan results.

## References

* [Argo CD](https://argoproj.github.io/cd/) declarative, GitOps continuous delivery tool for Kubernetes.

* [Loki](https://grafana.com/oss/loki/) monitoring stack.

### Security and Configuration

* [Datree](https://www.datree.io/)

* [Kubescape](https://hub.armo.cloud/docs)

* [kube-score](https://github.com/zegl/kube-score)

  `kube-score` is a tool that performs static code analysis of your Kubernetes object definitions.

* [OPA Gatekeeper Library](https://github.com/open-policy-agent/gatekeeper-library)

  A community-owned library of policies for the OPA Gatekeeper project.

* [Gatekeeper Policy Manager (GPM)](https://github.com/sighupio/gatekeeper-policy-manager)

  Gatekeeper Policy Manager is a simple read-only web UI for viewing OPA Gatekeeper policies' status in a Kubernetes Cluster.

* [Snyk Infrastructure as Code Action](https://github.com/snyk/actions/tree/master/iac)
