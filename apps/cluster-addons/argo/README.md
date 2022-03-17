# Access the Argo Workflows UI

By default, the Argo UI service is not exposed with an external IP.

To access the UI, use the following command:

```shell
kubectl -n argo port-forward svc/argo-server 2746:2746 &
```

Then visit: <https://127.0.0.1:2746>
