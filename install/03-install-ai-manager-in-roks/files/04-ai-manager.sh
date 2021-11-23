#!/usr/bin/env bash

echo "Installing IBM Cloud Pak for Watson AIOps AI Manager - AI Manager started"

echo "1. Install AI Manager ..."

cat << EOF | oc apply -f -
apiVersion: orchestrator.aiops.ibm.com/v1alpha1
kind: Installation
metadata:
  name: ibm-cp-watson-aiops
  namespace: cp4waiops
spec:
  imagePullSecret: ibm-entitlement-key
  license:
    accept: true
  pakModules:
  - name: aiopsFoundation
    enabled: true
  - name: applicationManager
    enabled: true
  - name: aiManager
    enabled: true
  - name: connection
    enabled: false
  size: small
  storageClass: ibmc-file-gold-gid
  storageClassLargeBlock: ibmc-file-gold-gid
EOF

echo "Process completed .... "
