# Sending Instana Events to WAIOps 3.2.0 AIMgr

This document explains about how to send Instana Events directly to WAIOps 3.2.0 AIMgr through Kafka topic.


## 1. Process

1. A Microservice called `WAIOps Hub` to be installed in WAIOps cluster.
2. Instana can send alers to `WAIOps Hub` via Webhook.
3. This `WAIOps Hub` will convert the instana events to NOI events and push the events to NOI Kafka topic in AIMgr.
4. AIMgr will process the event and create Alerts.

<img src="images/image1.png">

## 2. Installation

The `WAIOps Hub` can be installed via the script [files/deploy-waiops-hub.sh](./files/deploy-waiops-hub.sh). Here are the steps.

#### 1. Update NAMESPACE property

In the above script file, update the below property to point to WAIOps AIMgr installed namespace

```
NAMESPACE=cp4waiops
```

#### 2. Update NOI_KAFKA_TOPIC property

Update the below property to point to NOI Kafka topic that is created in AIMgr.

```
NOI_KAFKA_TOPIC=cp4waiops-cartridge-alerts-noi-7buu27a3
```

#### 3. Login into OCP Cluster

Login into the OCP Cluster where WAIOps AIMgr is installed 
```
oc login ....
```

#### 4. Install the WAIOps Hub

Run the script to install the WAIOps Hub microservice.

```
sh files/deploy-waiops-hub.sh
```

As a result, the WebHook url will be printed like the below.

  ===============================================================

WebHook URL : http://waiops-hub-core-waiops-hub-ns.aiops-320-4c84f197-0000.eu-de.containers.appdomain.cloud/api/core/instanaEvent

  ================================================================


#### 5. Create Instana Alert Channel

Create Instana alert channel with webhook and give the above printed url.

<img src="images/image2.png">


#### 6. Create Instana Alert

Create Instana `alert` for the corresponding Event and select the above created `Alert Channel`

<img src="images/image3.png">
<img src="images/image4.png">


#### 7. Generate the event and see the Alert in AIMgr AlertViewer.

Put the load in the application to generate the Instana event and see the event is created as alert in `Alert Viewer`.

<img src="images/image5.png">


## 3. Events and Mapping

### 3.1 Events Status : Open

#### Instana Event

- Instana Event :  [files/instana-event.json](./files/1-instana-event-open.json)

#### NOI Event

- Converted NOI Event :  [files/noi-event.json](./files/1-noi-event-open.json)

#### Mapping

<img src="images/1-mapping-open.png">


### 3.2 Events Status : Close

#### Instana Event

- Instana Event :  [files/instana-event.json](./files/2-instana-event-close.json)

#### NOI Event

- Converted NOI Event :  [files/noi-event.json](./files/2-noi-event-close.json)

#### Mapping

<img src="images/2-mapping-close.png">


## 4. ReInstall and Remove

To reinstall or remove this  `WAIOps Hub`, you can delete the namespace `waiops-hub-ns`.

```
oc delete ns waiops-hub-ns
```

## 5. Note

This is `WAIOps Hub` is intended for POC.



