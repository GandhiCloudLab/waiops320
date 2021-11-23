#!/usr/bin/env bash

echo "Installing IBM Cloud Pak for Watson AIOps AI Manager - Verify AI Manager operator install"


echo "1. Verify the AI Manager operator installation..."
oc get pods -n cp4waiops | grep ibm-aiops-orchestrator

## The output could be like this...
### ibm-aiops-orchestrator-6c7cfc85b7-j9c92                           1/1     Running   0          6m27s

echo "Process completed .... "
