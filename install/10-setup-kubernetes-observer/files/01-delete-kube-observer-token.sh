#!/usr/bin/env bash

echo "Process started"

NAMESPACE=kube-system
kubectl config set-context --current --namespace=$NAMESPACE

kubectl delete ClusterRoleBinding asm-k8s
kubectl delete ServiceAccount asm-k8s-account
kubectl delete ClusterRole asm:kubernetes-observer

echo "Process completed .... "
