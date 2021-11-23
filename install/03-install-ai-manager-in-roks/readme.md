# Installing Watson AIOps AI-Manager on ROKS

This document explains about Installing Watson AIOps AI-Manager on ROKS.

This document is based on the IBM Documentation https://www.ibm.com/docs/en/cloud-paks/cloud-pak-watson-aiops/3.2.0?topic=manager-starter-installation


## 1. Create Project, entitlement key secret and catalog source  

In this section we create the following.

- Create a custom project called `cp4waiops`
- Create an Operator group called `cp4waiops-operator-group` in your custom project `cp4waiops`
- Create the entitlement key pull secret called `ibm-entitlement-key`
- Create the catalog source called `ibm-operator-catalog`

Do the following.

1. Get `IBM entitlement key` from https://myibm.ibm.com/products-services/containerlibrary
2. Replace the value of the `ENTITLEMENT_KEY` variable in `files/01-project-secret-catalog-source.sh`
3. Run the command `sh files/01-project-secret-catalog-source.sh`

## 2. Install  AI-Manager operator

In this section, we install the AI-Manager operator by creating the `subscription` called `ibm-aiops-orchestrator` .

Do the following.

1. Run the command `sh files/02-ai-manager-operator.sh`

## 3. Verify  AI-Manager operator install completed

In this section, we verify the AI-Manager operator install is completed or not.

Do the following.

1. Run the command `sh files/03-verify-ai-manager-operator.sh`
2. It should print the output like this.
```
ibm-aiops-orchestrator-6c7cfc85b7-j9c92                           1/1     Running   0          6m27s
```
3. Repeat the command in step 1 until it is showing `Running` state.

## 4. Install AI-Manager

In this section, we install the AI-Manager by creating the `Installation` called `ibm-cp-watson-aiops` .

Do the following.

1. Run the command `sh files/04-ai-manager.sh`

Note that we use `ibmc-file-gold-gid` storage class here.

```
  storageClass: ibmc-file-gold-gid
  storageClassLargeBlock: ibmc-file-gold-gid
```

## 5. Verify AI-Manager install completed

In this section, we verify the AI-Manager install is completed or not.

Do the following.

1. Run the command `sh files/05-verify-ai-manager.sh`
2. It should print the output like this.
```
NAME                  PHASE     LICENSE    STORAGECLASS         STORAGECLASSLARGEBLOCK   AGE
ibm-cp-watson-aiops   Running   Accepted   ibmc-file-gold-gid   ibmc-file-gold-gid       8m1s
```
3. Repeat the command in step 1 until it is showing `Running` state.

4. Wait for 30 minutes to 1 hour time to get the install completed. After 1hr, make sure that no pods are in error state.

## 6. Print the AIOps Console URL details

In this section, we print the AIOps Console URL, user and password info.

Do the following.

1. Run the command `sh files/06-print-aiops-console-url-pwd.sh`
2. It should print the output like this.
```
====================================================================================
URL : https://cpd-cp4waiops.abcd-efg.containers.appdomain.cloud
USER: admin
PASSWORD: 
====================================================================================
```
3. You can use this to login into the WAIOps Console.


## 7. Update NGINX Certificate

In this section, update the nginx certificate.

Do the following.

1. Run the command `sh files/07-update-nginx-certificate.sh`

2. Wait for 3 or 4 minutes for the nginx pod to be up.
