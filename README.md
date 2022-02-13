# GitOps with Kubernetes using Argo CD & Kustomize

Repository contains YAML manifests to bootstrap a Kubernetes cluster maintained by [Argo CD](https://argoproj.github.io/cd/).

## Getting Started

The `scripts` folder contains bash shell scripts to help you get started running the repository applications in a local Kubernetes cluster.

Run the following scripts to install everything you will need:

```Shell
./install-cli-tools.sh    # only required to be performed on first run
./create-kind-cluster.sh
./install-apps.sh
```

Your cluster and applications are now running, time to start developing.

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

* Gatekeeper Policy Manager (GPM)

  <https://gpm.example.com/>

* Monitoring UI

  <https://loki.example.com>

  Loki monitoring stack contains Promtail, Grafana and Prometheus

  Get the admin users password:

  ```shell
  kubectl get secret --namespace monitoring loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
  ```

* Gitea

  <https://git.example.com>

  Login as the `gitea` user with the password `gitea`

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
