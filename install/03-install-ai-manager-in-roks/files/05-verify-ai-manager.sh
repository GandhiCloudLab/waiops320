#!/usr/bin/env bash

echo "Installing IBM Cloud Pak for Watson AIOps AI Manager - Verify AI Manager install"

echo "1. Verify AI Manager install ..."
echo "verify that your deployment has a PHASE of Running ..."

oc get installations.orchestrator.aiops.ibm.com -n cp4waiops


## The output could be like this...

# echo "NAME                  PHASE     LICENSE    STORAGECLASS         STORAGECLASSLARGEBLOCK   AGE"
# echo "ibm-cp-watson-aiops   Running   Accepted   ibmc-file-gold-gid   ibmc-file-gold-gid       8m1s"


echo "Process completed .... "
