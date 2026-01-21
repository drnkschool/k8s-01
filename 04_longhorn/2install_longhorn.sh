helm repo add longhorn https://charts.longhorn.io
helm repo update
kubectl create namespace longhorn-system
helm upgrade -i longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --values values.yaml
