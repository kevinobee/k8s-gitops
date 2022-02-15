# Argo CD Deployment Patches

Use `kubectl` to manually apply a JSON patch file to the cluster.

For example, to apply the [argocd-application-controller.jsonpatch.yaml](./argocd-application-controller.jsonpatch.yaml) patch file run the following command:

```shell
kubectl patch sts argocd-application-controller -n argocd --type json --patch "$(cat argocd-application-controller.jsonpatch.yaml)"
```
