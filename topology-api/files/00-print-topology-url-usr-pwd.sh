#!/bin/bash

echo "process started ..... $(date)"

NAMESPACE=cp4waiops

TOPO_API_URL=$(oc get routes aiops-topology-topology  -n $NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}')
TOPO_USER=$(oc get secret -n $NAMESPACE aiops-topology-asm-credentials -o jsonpath="{.data.username}"|base64 -d) ;
TOPO_PWD=$(oc get secret -n $NAMESPACE aiops-topology-asm-credentials -o jsonpath="{.data.password}"|base64 -d) ;
TOPO_TENENT_ID=cfd95b7e-3bc7-4006-a4a8-a73a79c71255

echo "================================================================"
echo "TOPO_API_URL=https://$TOPO_API_URL/1.0/topology"
echo "TOPO_API_URL_SWAGGER=https://$TOPO_API_URL/1.0/topology/swagger"
echo "TOPO_USER=$TOPO_USER"
echo "TOPO_PWD=$TOPO_PWD"
echo "TOPO_TENENT_ID=$TOPO_TENENT_ID"
echo "================================================================"

echo "process completed ..... $(date)"
