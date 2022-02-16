#!/bin/bash
echo "process started ..... $(date)"

#########################################################
## Namespace where WAIOps is installed.
NAMESPACE=cp4waiops

## Namespace where this hub has to be installed
NAMESPACE_HUB=waiops-hub-ns

## KAFKA Topic to push Instana events as NOI events
NOI_KAFKA_TOPIC=cp4waiops-cartridge-alerts-noi-7buu27a3

## Allow Instana events with severity from and to
FILTER_SEVERITY_ENABLED=false
FILTER_SEVERITY_FROM=1
FILTER_SEVERITY_TO=1000

### -----------------------------------------------------

TRUSTSTORE_PASSWORD=mystorekeypass
JKS_FILENAME=waiops-hub-keystore.jks
CRT_FILENAME=waiops-hub-ca.crt
SASL_USERNAME=cp4waiops-cartridge-kafka-auth
#########################################################

### Retrieve ca.crt
oc extract secret/iaf-system-cluster-ca-cert  -n $NAMESPACE --keys=ca.crt --to=-> $CRT_FILENAME

### Retrieve SASL password 
export SASL_PASSWORD=$(oc get secret $SASL_USERNAME  -n $NAMESPACE --template={{.data.password}} | base64 --decode)

### Retrieve Kafka Broker url
export BROKER=$(oc get routes iaf-system-kafka-bootstrap -n $NAMESPACE -o=jsonpath='{.status.ingress[0].host}{"\n"}'):443

oc get routes iaf-system-kafka-bootstrap -n cp4waiops -o=jsonpath='{.status.ingress[0].host}{"\n"}'

### Generate jks file
keytool -import -noprompt -alias alias -file $CRT_FILENAME -keypass wahubkeypass -keystore $JKS_FILENAME -storepass $TRUSTSTORE_PASSWORD

### create ns for this hub
oc create ns $NAMESPACE_HUB

### create secret for jks
oc delete secret waiops-hub-secret -n $NAMESPACE_HUB 
oc create secret generic -n $NAMESPACE_HUB waiops-hub-secret --from-file=truststore.jks=$JKS_FILENAME

### create configmap
oc delete configmap waiops-hub-configmap -n $NAMESPACE_HUB 
oc create configmap -n $NAMESPACE_HUB waiops-hub-configmap --from-literal=noiKafkaTopic=$NOI_KAFKA_TOPIC --from-literal=noiKafkaServerUrl=$BROKER --from-literal=noiKafkaTruststoreLocation=/opt/secret-volume/truststore.jks --from-literal=noiKafkaTruststorePassword=$TRUSTSTORE_PASSWORD  --from-literal=noiKafkaSCRAMUserName=$SASL_USERNAME  --from-literal=noiKafkaSCRAMPassword=$SASL_PASSWORD --from-literal=filterSeverityEnabled=$FILTER_SEVERITY_ENABLED  --from-literal=filterSeverityFrom=$FILTER_SEVERITY_FROM  --from-literal=filterSeverityTo=$FILTER_SEVERITY_TO  

### delete the temp files...
ls -l
rm $JKS_FILENAME
rm $CRT_FILENAME

### create Kubernetes objects

cat <<EOF | oc apply -f -

kind: Deployment
apiVersion: apps/v1
metadata:
  name: waiops-hub-core
  namespace: $NAMESPACE_HUB
  labels:
    app: waiops-hub-application
    subname: waiops-hub-core
spec:
  selector:
    matchLabels:
      app: waiops-hub-application
      subname: waiops-hub-core
  replicas: 1
  template:
    metadata:
      labels:
        app: waiops-hub-application
        subname: waiops-hub-core
    spec:
      volumes:
      - name: secret-volume
        secret:
          secretName: waiops-hub-secret
          items:
          - key: truststore.jks
            path: truststore.jks          
      containers:
        - name: cont-waiops-hub-core
          image: "gandigit/waiops-hub-core:0.0.2"
          imagePullPolicy: Always
          ports:
            - name: my-http
              containerPort: 9192
              protocol: TCP
            - name: https
              containerPort: 8082              
          envFrom:
            - configMapRef:
                name: waiops-hub-configmap
          volumeMounts:
          - name: secret-volume
            mountPath: "/opt/secret-volume"
---
apiVersion: v1
kind: Service
metadata:
  name: waiops-hub-core
  namespace: $NAMESPACE_HUB
  labels:
    app: waiops-hub-application
    subname: waiops-hub-core
spec:
  type: ClusterIP
  ports:
    - name: my-http
      port: 9192
      targetPort: my-http
  selector:
    app: waiops-hub-application
    subname: waiops-hub-core
---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: waiops-hub-core
  namespace: $NAMESPACE_HUB
  labels:
    app: waiops-hub-application
    subname: waiops-hub-core
spec:
  path: /
  to:
    kind: Service
    name: waiops-hub-core
    weight: 100
  port:
    targetPort: my-http
EOF

## Delete the pods with the name "waiops-hub-core"
oc get pods -n $NAMESPACE_HUB  --no-headers=true | awk '/waiops-hub-core/{print $1}'| xargs  oc delete  -n $NAMESPACE_HUB pod

## Print the Webhook URL
export URL=$(oc get routes waiops-hub-core -n $NAMESPACE_HUB -o=jsonpath='{.status.ingress[0].host}{"\n"}')
echo "================================================================"
echo " WebHook URL : http://$URL/api/core/instanaEvent"
echo "================================================================"

echo "process completed ..... $(date)"
