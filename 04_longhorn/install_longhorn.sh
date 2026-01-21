kubectl -n longhorn-system delete daemonset longhorn-manager
kubectl -n longhorn-system delete deployment longhorn-driver-deployer
kubectl -n longhorn-system get all -o name \
| xargs -L1 kubectl -n longhorn-system annotate --overwrite meta.helm.sh/release-name- meta.helm.sh/release-namespace-
kubectl get daemonset longhorn-manager -n longhorn-system -o json \
   | jq 'del(.metadata.managedFields)' \
   | kubectl replace --force -f -
helm upgrade -i longhorn longhorn/longhorn --namespace longhorn-system --create-namespace  -f values.yaml
