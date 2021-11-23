#!/usr/bin/env bash

echo "Installing IBM Cloud Pak for Watson AIOps AI Manager - started"

## Entitlement key
ENTITLEMENT_KEY=ABCD

echo "1. Create namespace cp4waiops ..."
oc create namespace cp4waiops

echo "2. Create OperatorGroup ..."
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: cp4waiops-operator-group
  namespace: cp4waiops
spec:
  targetNamespaces:
    - cp4waiops
EOF


echo "3. Create the entitlement key pull secret ..."
oc create secret docker-registry ibm-entitlement-key \
    --docker-username=cp\
    --docker-password=$ENTITLEMENT_KEY \
    --docker-server=cp.icr.io \
    --namespace=cp4waiops


echo "4. Ensure external traffic access to AI Manager"
if [ $(oc get ingresscontroller default -n openshift-ingress-operator -o jsonpath='{.status.endpointPublishingStrategy.type}') = "HostNetwork" ]; then oc patch namespace default --type=json -p '[{"op":"add","path":"/metadata/labels","value":{"network.openshift.io/policy-group":"ingress"}}]'; fi


echo "5. Create catalog source"
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-operator-catalog
  publisher: IBM Content
  sourceType: grpc
  image: icr.io/cpopen/ibm-operator-catalog:latest
EOF

echo "Process completed .... "
