# Watson AIOps 3.2.0 installation and demo setup requirements.

This documentation explains about the Hardware and account requirements for for Watson AIOps 3.2.0 installation and demo setup.

## 1. RedHat Openshift on IBM Cloud

A RedHat Openshift on IBM Cloud (ROKS) with the below configuration needed to install Watson AIOps 3.2

 - OCP Version : 4.8.18
 - 5 Nodes with b3c.16x64 flavour. (CPU 16 core, Memory 64 GB)
 - Classic Infrastructure

 Here is a reference values and steps for install [install](../50-install-roks).

## 2. IKS Cluster on IBM Cloud

A IBM Cloud Kubernetes Service, cluster on IBM cloud is needed to install iLender application (a sample application). This is required for WAIOps demo setup.

 - Kubernetes Version : 1.19.15_1565
 - 1 Node with b3c.8x32 flavour. (CPU 8 core, Memory 32 GB)
 - Classic Infrastructure

## 3. Humio VM

A VM with the below configuration is needed for Humio Logging System installation as part of the WAIOps demo setup.

 - OS : CentOS Linux 8
 - CPU : 16 Core
 - Memory : 64 GB

## 4. Slack Account

SRE would be indicated about the incident through ChatOps such as Slack or Team. 

Slack account is required for the WAIOps demo setup.

The below url explains about account creation and integration with WAIOps.

https://github.ibm.com/JeyaGandhi/ai-ops-310-guide-d/tree/master/300-aiops-initial-configuration/13-slack-account-creation-and-integration


## 5. ServiceNow Account

A ServiceNow account is required or atleast Developer instance to be created using the below URL as part of the WAIOps demo setup..

https://developer.servicenow.com/dev.do#!/guides/paris/developer-program/pdi-guide/obtaining-a-pdi

Watson AIOps can create Incidents in ServiceNow apart from slack story. It also train the existing incidents from ServiceNow for identifying the Similar Incidents and to choose the next best action, in case of an incident.
