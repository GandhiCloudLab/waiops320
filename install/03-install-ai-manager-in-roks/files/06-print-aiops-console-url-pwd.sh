#!/usr/bin/env bash

echo "Printing AI Manager console access details..."

MY_URL=$(oc get route -n cp4waiops cpd -o jsonpath={.spec.host})
MY_PASSWORD=$(oc -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d)

echo "===================================================================================="
echo "URL : https://$MY_URL"
echo "USER: admin"
echo "PASSWORD: $MY_PASSWORD"
echo "===================================================================================="