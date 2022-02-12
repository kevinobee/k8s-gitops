# Kubernetes GitOps

kind delete cluster
kind create cluster

# devops scan on bare cluster
kubescape scan framework devopsbest --exclude-namespaces kube-system,kube-public --fail-threshold 0 --enable-host-scan


kubectl kustomize apps > apps.yaml

datree test apps.yaml --ignore-missing-schemas --schema-version 1.21.0


kubectl apply -f apps.yaml

# wait for deployments
kubectl get deployment -A -w
watch curl -D- http://172.18.0.200 -H 'Host: argocd.example.com'
curl -D- https://172.18.0.200 -H 'Host: k8s.example.com' -s -v

# use k8s dashboard
kubectl get secret dashboard-admin-sa-token-ggwfx -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 -d && echo

# full scan on populated cluster
kubescape scan framework devopsbest,nsa,mitre,armobest,devopsbest --exclude-namespaces kube-system,kube-public --fail-threshold 0 --enable-host-scan

# view working differences
kubectl kustomize apps | kubectl diff -f -

# clean-up
kind delete cluster
