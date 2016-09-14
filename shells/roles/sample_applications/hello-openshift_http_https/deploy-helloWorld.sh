#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.09.09
# Purpose: This script help deploy hello-openshift image and also https route. Therefore, it would be a good application to do health check for F5
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160909   jooho   Create
#
#
#

#. $CONFIG_PATH/ose_config.sh


usage() {
  echo ""
  echo "Usage"
  echo ""
  echo "$0 <PROJECT_NAME> <HOST_NAME> <SIGNER_KEY> <SIGNER_CERT> <SIGNER_SERIAL>"
  echo "$0 helloworld helloworld.cloudapps.example.com  /etc/origin/master/ca.key /etc/origin/master/ca.crt /etc/origin/master/ca.serial.txt"
  echo "$0 helloworld helloworld.cloudapps.example.com  ./ca.key ./ca.crt ./ca.serial.txt"
  echo ""
  echo "Note: $0 has sample output"
  if [[ -n $ERR ]]
  then
    echo ""
    echo "ERROR:  ${ERR}"
  fi
  exit 9
}
if [ $# -ne 5 ]
then
  usage
fi



export PROJECT_NAME=$1
export HOST_NAME=$2
export PRIVATE_KEY_FILE=$3
export CA_CERT_FILE=$4
export SERIAL_FILE=$5

##Create new project
oc new-project ${PROJECT_NAME}
if [[  $? == "1" ]]; then
   echo "Note! Same project exist!! Please check it first then try to execute this script"
   exit 9
fi


# Create Self Signed Cert and Route

## Create CSR/PRIVATE Key
echo " Create RSA Private Key "
#openssl genrsa  -out ${HOST_NAME}.key 2048

echo " Create CSR/PRIVATE Key "
openssl req -new -newkey rsa:2048 -nodes -out ${HOST_NAME}.csr -keyout ${HOST_NAME}.key -subj "/C=US/ST=North Carolina/L=Raleigh/O=Red Hat/OU=PaaS Practics/CN=${HOST_NAME}"
#openssl req -new  -nodes -out ${HOST_NAME}.csr -key ${HOST_NAME}.key -subj "/C=US/ST=North Carolina/L=Raleigh/O=Red Hat/OU=PaaS Practics/CN=${HOST_NAME}"

## Create CRT file
echo " Create CRT file"
openssl x509 -req -in ${HOST_NAME}.csr  -CA ${CA_CERT_FILE} -CAkey ${PRIVATE_KEY_FILE} -CAserial ${SERIAL_FILE} -out ${HOST_NAME}.crt -days 500

## Call generate_route.sh to create json file
../../install/generate_route.sh hello-openshift ${HOST_NAME} ${HOST_NAME}.key  ${HOST_NAME}.crt ${CA_CERT_FILE}

# Start creating objects : DC/SVC/ROUTE
## Create DC
oc create -f ./helloworld-template.json

## Create Service
oc create -f ./helloworld-service.json

## Create Route
oc create -f ./${HOST_NAME}-route.json




# "oadm ca create-server-cert --signer-cert=$CA/ca.crt  --signer-key=$CA/ca.key --signer-serial=$CA/ca.serial.txt --hostnames=\"${target_hostname}\"  --cert=${target_hostname}.crt --key=${target_hostname}.key

