helm repo add metallb https://metallb.github.io/metallb
kubectl create namespace metallb-system
helm repo update
helm upgrade -i -n metallb-system metallb metallb/metallb -f metallb-values.yaml -f ipaddrpool.yaml
