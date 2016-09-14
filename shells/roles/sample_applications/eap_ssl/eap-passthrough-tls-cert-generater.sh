#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.08.05
# Purpose: This script help create key for eap https protocol
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160805   jooho    Create
#
#
#
#  Usage:
#
#   ./eap-passthrough-tls-cert-generater.sh PROJECT_NAME
# 
# (Sample)
# [root@aoappd-w-dev001 route-egde-reencrypte-passthrough]# ./eap-passthrough-tls-cert-generater.sh test
#   What is your first and last name?
#    [Unknown]:  Red Hat
#   What is the name of your organizational unit?
#    [Unknown]:  Red Hat
#   What is the name of your organization?
#    [Unknown]:  Red Hat
#   What is the name of your City or Locality?
#    [Unknown]:  Toronto
#   What is the name of your State or Province?
#    [Unknown]:  ON
#   What is the two-letter country code for this unit?
#    [Unknown]:  CA
#   Is CN=Red Hat, OU=Red Hat, O=Red Hat, L=Toronto, ST=ON, C=CA correct?
#    [no]:  yes
#
#   Enter key password for <selfsigned>
#          (RETURN if same as keystore password): supersecret
#   Re-enter new password: supersecret
#   secret/eap-app-secret
#   serviceaccount "eap-service-account" created
#
# Create EAP Application
# oc new-app --template=eap64-https-s2i -p HTTPS_NAME=selfsigned,HTTPS_PASSWORD=supersecret
#
# --> Deploying template eap64-https-s2i in project openshift for "eap64-https-s2i"
#      With parameters:
#       APPLICATION_NAME=eap-app
#       HOSTNAME_HTTP=
#       HOSTNAME_HTTPS=
#       SOURCE_REPOSITORY_URL=https://github.com/jboss-developer/jboss-eap-quickstarts
#       SOURCE_REPOSITORY_REF=6.4.x
#       CONTEXT_DIR=kitchensink
#       HORNETQ_QUEUES=
#       HORNETQ_TOPICS=
#       HTTPS_SECRET=eap-app-secret
#       HTTPS_KEYSTORE=keystore.jks
#       HTTPS_NAME=selfsigned
#       HTTPS_PASSWORD=supersecret
#       HORNETQ_CLUSTER_PASSWORD=Itb7UbWE # generated
#       GITHUB_WEBHOOK_SECRET=41ReHmnA # generated
#       GENERIC_WEBHOOK_SECRET=hqN1DU2C # generated
#       IMAGE_STREAM_NAMESPACE=openshift
#       JGROUPS_ENCRYPT_SECRET=eap-app-secret
#       JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks
#       JGROUPS_ENCRYPT_NAME=
#       JGROUPS_ENCRYPT_PASSWORD=
#       JGROUPS_CLUSTER_PASSWORD=OqFyILML # generated
# --> Creating resources with label app=eap-app ...
#     Service "eap-app" created
#     Service "secure-eap-app" created
#     Route "eap-app" created
#     Route "secure-eap-app" created
#     ImageStream "eap-app" created
#     BuildConfig "eap-app" created
#     DeploymentConfig "eap-app" created
# --> Success
#     Build scheduled for "eap-app" - use the logs command to track its progress.
#     Run 'oc status' to view your app.

# 3. Open Broswer and Go to "https://secure-eap-app-test.${subdomain}"


usage() {
  echo ""
  echo "Usage"
  echo ""
  echo "$0 <PROJECT_NAME> "
  echo "$0 EAP_HTTPS_TEST "
  echo ""
  echo "Note: $0 has sample output"
  if [[ -n $ERR ]]
  then
    echo ""
    echo "ERROR:  ${ERR}"
  fi
  exit 9
}
if [ $# -ne 1 ]
then
  usage
fi

##Create new project
if [[ ! $(oc get project $1) == "" ]]; then
   echo "Note! Same project exist!! Please check it first then try to execute this script"
   exit 9
else
   oc new-project $1
fi

# passthrough
## Create jks file
if [[ ! -f keystore.jks ]]; then
  echo "keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass supersecret -validity 360 -keysize 2048"
  keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass supersecret -validity 360 -keysize 2048
else
  echo "keystore.jks exist and it will use it"
fi

## Register secret
oc secrets new eap-app-secret keystore.jks

## Create SA "eap-app-secret"
echo '{
  "apiVersion": "v1",
  "kind": "ServiceAccount",
  "metadata": {
    "name": "eap-service-account"
  },
    "secrets": [
        {
            "name": "eap-app-secret"
        }
   ]
}' | oc create -f -

echo " "
## Create EAP Application
echo "## Create EAP Application ##"
echo "oc new-app --template=eap64-https-s2i -p HTTPS_NAME=selfsigned,HTTPS_PASSWORD=supersecret"
echo " "

oc new-app --template=eap64-https-s2i -p HTTPS_NAME=selfsigned,HTTPS_PASSWORD=supersecret
