# Cluster Addons

The [gitops/cluster-addons.yaml](../../gitops/cluster-addons.yaml) manifest defines an Argo CD [ApplicationSet](https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/) that will create an `Application` resource for each folder container in this folder.

## Working with Cluster Addons

The conventions used to generate GitOps resources for cluster addon applications are:

* Cluster addons directory name defines the `namespace` to be deployed and the Argo CD `Application` name.

* [kustomization.yaml](kustomization.yaml) contains a `base` for every cluster addon directory and each cluster addon folder contains it's own `kustomization.yaml` file.
