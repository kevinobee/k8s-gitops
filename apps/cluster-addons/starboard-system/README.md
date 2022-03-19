# Starboard

> Kubernetes-native security toolkit

See Aqua's [Starboard Git repo](https://github.com/aquasecurity/starboard) for full documentation.

## Getting Started

To apply the Starboard tooling to the cluster by running the following command:

```shell
kubectl kustomize apps/cluster-addons/starboard-system --enable-helm | kubectl apply -f -
```

To view the report resources available in the cluster run the following command:

```shell
kubectl api-resources --api-group aquasecurity.github.io
```

## References

* [Starboard Octant Plugin](https://github.com/aquasecurity/starboard-octant-plugin)
