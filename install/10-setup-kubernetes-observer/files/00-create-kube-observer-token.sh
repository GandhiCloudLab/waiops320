#!/usr/bin/env bash

echo "Process started"

NAMESPACE=kube-system
kubectl config set-context --current --namespace=$NAMESPACE

cat <<EOF | kubectl apply -f -

kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  name: asm:kubernetes-observer
rules:
- apiGroups: [""]
  resources: [ "pods", "namespaces", "nodes", "services", "endpoints", "persistentvolumes", "persistentvolumeclaims"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]
  resources: ["replicasets", "deployments", "statefulsets", "daemonsets"]
  verbs: ["get", "list"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: asm-k8s-account
  namespace: $NAMESPACE
--- 
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: asm-k8s
  namespace: $NAMESPACE
roleRef:
  kind: ClusterRole
  name: asm:kubernetes-observer
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: asm-k8s-account
  namespace: $NAMESPACE

EOF

TOKEN=$(kubectl get secrets $(kubectl get secrets | grep asm-k8s-account-token | awk '{print $1}' | head -1) -o jsonpath="{.data.token}"| base64 --decode )
echo "===================================================================================="
echo $TOKEN
echo "===================================================================================="

echo "Process completed .... "
