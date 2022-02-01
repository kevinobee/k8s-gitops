# Security in Kubernetes - How to do it right

> Run Containers and Pods securely in Kubernetes

## Process Steps

The steps outlined below provide guidance on securing your Kubernetes cluster and the code running on it.

1. [Secure Images](#secure-images)
1. [Secure Containers and Pods](#secure-containers-and-pods)
1. [Secure Communication between Pods](#secure-communication-between-pods)
1. [Securing Secrets Data](#securing-secrets-data)
1. [Securing Access to K8s cluster](#securing-access-to-k8s-cluster)
1. [Runtime attacks](#runtime-attacks)

### Secure Images

Issues:

- Code from untrusted registries
- Vulnerabilities in tools / OS / code libraries
- Bloated base images

Fixes:

- Use approved lean images

- Whitelist trusted registries

  See [repo-constraints.yaml](./apps/gatekeeper/base/constraints.yaml) for an example of using the [K8sAllowedRepos](https://github.com/open-policy-agent/gatekeeper-library/blob/master/library/general/allowedrepos/template.yaml) Gatekeeper library OPA constraint to whitelist trusted registries.

- Automated Image scanning

  Use tools like [Snyk Infrastructure as Code Action](https://github.com/snyk/actions/tree/master/iac), [Datree](https://www.datree.io/) and [Kubescape](https://hub.armo.cloud/docs) to scan images at build time and those in registry

  Refer to the [Static Analysis](https://github.com/kevinobee/k8s-gitops/actions/workflows/static-analysis.yml) action and [Code scanning alerts](https://github.com/kevinobee/k8s-gitops/security/code-scanning) on GitHub for security and configuration scan results.

### Secure Containers and Pods

Issues:

- Don't run containers with root
- Avoid running privileged pods
- Set limits on cluster resources for containers

Fixes:

- Resource quotas per namespace
- Limit ranges

### Secure Communication between Pods

- Network policies
- Use Namespaces to keep resources and teams separate
- Service mesh
  - mTLS, communication rules

### Securing Secrets Data

- Encrypt etcd store
- Enable Kubernetes EncryptionConfiguration Feature
- Vault

### Securing Access to K8s cluster

Issues:

- Users and permissions in Kubernetes
- Authentication via kube api server
  - client certificates for human users
  - service accounts for non-human users
- Authorization via RBAC
  - cluster wide
  - namespace scoped
- Access to our application
  - don't use `NodePort` or `LoadBalancer`

Fixes:

- Block use of `NodePort` in manifests.

  See [constraints.yaml](./apps/gatekeeper/base/constraints.yaml) for an example of using the [K8sBlockNodePort](https://github.com/open-policy-agent/gatekeeper-library/blob/master/library/general/block-nodeport-services/template.yaml) Gatekeeper library OPA constraint to disallows all Services with type NodePort.

### Runtime Attacks

Issues:

- Monitoring and logging
  - visibility - prometheus and fluent bit
  - aims to mitigate runtime attacks
- UI dashboards

Fixes:

- Enable Metadata audit logging in Kubernetes cluster

- Create security dashboard to visualize potential runtime attacks and related audit event logs

## References

- [Security in Kubernetes - How to do it right!](https://www.youtube.com/watch?v=9OGIaaOYTEA)
