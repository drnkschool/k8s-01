#helm install cilium

helm repo add cilium https://helm.cilium.io/
helm repo update
helm upgrade -i cilium cilium/cilium --namespace kube-system --set operator.replicas=1 -f values.yaml
