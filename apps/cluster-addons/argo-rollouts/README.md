# Access the Argo Rollouts Dashboard

The Argo Rollouts Kubectl plugin can serve a local UI Dashboard to visualize your Rollouts.

Install the kubectl plugin using brew:

```shell
brew install argoproj/tap/kubectl-argo-rollouts
```

To start it, run the following command:

```shell
kubectl argo rollouts dashboard -n argo-rollouts &
```

Then visit: <http://localhost:3100>
