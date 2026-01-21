#!/usr/bin/env bash
set -euo pipefail

echo "=== 1) Останавливаем Longhorn и приложения ==="

# Longhorn
kubectl scale deployment -n longhorn-system --all --replicas=0 || true
kubectl scale daemonset  -n longhorn-system --all --replicas=0 || true

# Основные неймспейсы с PVC
for ns in harbor nextcloud authentik netbox planka v-metrics; do
  kubectl scale deploy -n "$ns" --all --replicas=0 2>/dev/null || true
  kubectl scale statefulset -n "$ns" --all --replicas=0 2>/dev/null || true
done

echo "=== 2) Снимаем финализаторы со всех PVC со storageClass=longhorn ==="

# Патчим ВСЕ PVC со storageClass=longhorn
kubectl get pvc --all-namespaces -o json \
  | jq '
    .items
    | map(select(.spec.storageClassName=="longhorn"))
    | .[] 
    | {name: .metadata.name, ns: .metadata.namespace}
  ' -c | while read -r line; do
    name=$(echo "$line" | jq -r '.name')
    ns=$(echo "$line"   | jq -r '.ns')
    echo "Patch PVC $ns/$name"
    kubectl patch pvc "$name" -n "$ns" -p '{"metadata":{"finalizers":null}}' || true
  done

echo "=== 3) Снимаем финализаторы и меняем reclaimPolicy у всех PV со storageClass=longhorn ==="

kubectl get pv -o json \
  | jq '
    .items
    | map(select(.spec.storageClassName=="longhorn"))
    | .[]
    | {name: .metadata.name}
  ' -c | while read -r line; do
    pv=$(echo "$line" | jq -r '.name')
    echo "Patch PV $pv"
    # Убираем финализаторы
    kubectl patch pv "$pv" -p '{"metadata":{"finalizers":null}}' || true
    # Меняем политику на Retain
    kubectl patch pv "$pv" -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}' || true
  done

echo "=== 4) Меняем reclaimPolicy у StorageClass longhorn на Retain ==="

kubectl patch storageclass longhorn -p '{"reclaimPolicy":"Retain"}' || true

echo "=== Готово. Проверьте состояние ==="
kubectl get pvc --all-namespaces
kubectl get pv

