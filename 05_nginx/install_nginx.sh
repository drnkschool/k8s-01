helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace ingress-nginx
helm upgrade -i nginx-ingress ingress-nginx/ingress-nginx   --namespace ingress-nginx   -f nginx-values.yaml
