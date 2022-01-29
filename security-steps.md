# Security in Kubernetes - How to do it right

> Run Containers and Pods securely in Kubernetes

## Process Steps

1. Secure Images

    - code from untrusted registries
    - Vulnerabilities in tools / OS / code libraries
    - Bloated base images

    Fixes:
    - approved lean images
    - list of trusted registries
    - image scanning
        - snyk
        - scan during build
        - scan in registry

1. Secure Containers and Pods

    - don't run containers with root
    - avoid running privileged pods
    - set limits on cluster resources for containers

    Fixes:
    - resource quotas per namespace
    - limit ranges

1. Secure Communication between Pods

    - network policies
    - namespaces to keep resources and teams separate
    - service mesh
        - mTLS, communication rules

1. Securing Secrets Data

    - encrypt etcd store
    - k8s EncryptionConfiguration Feature
    - Vault

1. Securing Access to K8s cluster

    - users and permissions in kubernetes
    - authentication via kube api server
        - client certificates for human users
        - service accounts for non-human users
    - authorization via RBAC
        - cluster wide
        - namespace scoped
    - access to our application
        - don't use NodePort or LoadBalancer

1. Runtime attacks - Threat defense

    - monitoring and logging
        - visibility - prometheus and fluent bit
        - aims to mitigate runtime attacks
    - ui dashboards

## References

- [Security in Kubernetes - How to do it right!](https://www.youtube.com/watch?v=9OGIaaOYTEA)
