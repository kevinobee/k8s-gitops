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

## Cluster Applications

Applications running in the cluster are exposed via a load balancer and ingress as follows:

* Argo CD

  <https://argocd.local/>

  Admin users password stored in `ARGOCD_PWD` environment variable.

  ```shell
  export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
  echo ${ARGOCD_PWD}
  ```

* Kubernetes dashboard

  <https://k8s.local/>

  Admin access token stored in `K8S_TOKEN` environment variable.

  ```shell
  K8S_TOKEN_NAME=$(kubectl get secret -n kubernetes-dashboard -o name | grep dashboard-admin-sa-token)
  export K8S_TOKEN=$(kubectl get $K8S_TOKEN_NAME -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 --decode)
  echo ${K8S_TOKEN}
  ```

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

* Gitea

  <https://git.local>

  Login as the `gitea` user with the password `gitea`

### Host Names

Setup entries for `.local` domain names in your `/etc/hosts` file by running the following commands after the `install.sh` script has completed:

```shell
LB_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo "${LB_IP} argocd.local gpm.local k8s.local loki.local git.local" | sudo tee -a /etc/hosts
```

## GitOps

To wire up GitOps applications in Argo CD run the following commands after the `install.sh` script:

```shell
# Create GitOps application in Argo CD (App of Apps)
kubectl apply -k gitops

# View Argo CD applications deployment status
kubectl get applications.argoproj.io -n argocd
```

## Build Automation

Refer to the [Static Analysis](https://github.com/kevinobee/k8s-gitops/actions/workflows/static-analysis.yml) action and [Code scanning alerts](https://github.com/kevinobee/k8s-gitops/security/code-scanning) on GitHub for security and configuration scan results.

## References

* [Deploying Kubernetes Dashboard with Argo/Kustomize](https://www.frakkingsweet.com/deploying-kubernetes-dashboard-with-argo-kustomize/) blog post

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

### Developer Applications

* [Gitea](https://gitea.com/)
