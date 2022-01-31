# Security in Kubernetes - How to do it right

> Run Containers and Pods securely in Kubernetes

## Process Steps

The steps outlined below provide guidance on securing your Kubernetes cluster and the code running on it. The steps are ordered in priority of consideration.

1. Secure Images
1. Secure Containers and Pods
1. Secure Communication between Pods
1. Securing Secrets Data
1. Securing Access to K8s cluster
1. Runtime attacks - Threat defense

### Secure Images

    Issues:

    - Code from untrusted registries
    - Vulnerabilities in tools / OS / code libraries
    - Bloated base images

    Fixes:

    - Use approved lean images

    - Whitelist trusted registries

      See [repo-constraints.yaml](./apps/gatekeeper/base/constraints.yaml) for an example of using the [K8sAllowedRepos](https://github.com/open-policy-agent/gatekeeper-library/blob/master/library/general/allowedrepos/template.yaml) Gatekeeper library OPA constraint to whitelist trusted registries.

    - Image scanning
        - Snyk
        - scan during build
        - scan in registry

### Secure Containers and Pods

    - don't run containers with root
    - avoid running privileged pods
    - set limits on cluster resources for containers

    Fixes:
    - resource quotas per namespace
    - limit ranges

### Secure Communication between Pods

    - network policies
    - namespaces to keep resources and teams separate
    - service mesh
        - mTLS, communication rules

### Securing Secrets Data

    - encrypt etcd store
    - k8s EncryptionConfiguration Feature
    - Vault

### Securing Access to K8s cluster

    - users and permissions in kubernetes
    - authentication via kube api server
        - client certificates for human users
        - service accounts for non-human users
    - authorization via RBAC
        - cluster wide
        - namespace scoped
    - access to our application
        - don't use NodePort or LoadBalancer

### Runtime attacks - Threat defense

    - monitoring and logging
        - visibility - prometheus and fluent bit
        - aims to mitigate runtime attacks
    - ui dashboards

## References

- [Security in Kubernetes - How to do it right!](https://www.youtube.com/watch?v=9OGIaaOYTEA)
