#!/usr/bin/env bash

echo "Installing IBM Cloud Pak for Watson AIOps AI Manager - AI Manager operator started"

echo "1. Install  AI Manager operator"
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-aiops-orchestrator
  namespace: cp4waiops
spec:
  channel: v3.2
  installPlanApproval: Automatic
  name: ibm-aiops-orchestrator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

echo "Process completed .... "
