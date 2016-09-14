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

. $CONFIG_PATH/ose_config.sh


# Generate JSON file to create HTTPS(TLS Edge) Route for Hello OpenShift!
generate_route_json(){

cat << EOF > ${HOST_NAME}-route.json
{
    "kind": "Route",
    "apiVersion": "v1",
    "metadata": {
        "name": "$HOST_NAME"
    },
    "spec": {
        "host": "$HOST_NAME",
        "to": {
            "kind": "Service",
            "name": "$SVC_NAME"
        },
        "tls": {
            "termination": "edge",
            "certificate": "${CERTS_TXT[@]}",
            "key": "${PRIVATE_KEY_TXT[@]}",
            "caCertificate": "${CA_CERT_TXT[@]}",
            "insecureEdgeTerminationPolicy": "Allow"
           }
    }
}
EOF

}



usage() {
  echo ""
  echo "Usage"
  echo ""
  echo "$0 <HOST_NAME> <SVC_NAME> <PRIVATE_KEY_FILE> <CERT_FILE> <CA_CERT_FILE>"
  echo "$0 helloworld.cloudapps.example.com hello-openshift private.key cert.crt /etc/origin/master/ca.crt "
  echo "$0 helloworld.cloudapps.example.com hello-openshift private.key cert.crt ./ca.crt "
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

export HOST_NAME=$1
export SVC_NAME=$2
export PRIVATE_KEY_FILE=$3
export CERT_FILE=$4
export CA_CERT_FILE=$5


## Format Private Key/Cert for json file.
export BEGIN_CERT="-----BEGIN CERTIFICATE-----"
export END_CERT="-----END CERTIFICATE-----"
export BEGIN_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----"
export END_PRIVATE_KEY="-----END PRIVATE KEY-----"
export BEGIN_RSA_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----"
export END_RSA_PRIVATE_KEY="-----END RSA PRIVATE KEY-----"
export begin=1  # This value is used when cert file have several certs.
export CERTS_TXT
export PRIVATE_KEY_TXT
export CA_CERT_TXT

## Formatted certs
if [[ $(grep END ${CERT_FILE}|wc -l) != 1 ]]; then      #If there are several certs in the crt file
    for i in $(grep -n END ${CERT_FILE} |cut -d: -f1)
    do
         single_cert=$(sed -n "$begin,$i p" ${CERT_FILE})
         temp_txt=$(echo $single_cert|awk '{$1=$2="";$0=$0;$1=$1;$(NF-1)=$(NF)=""}1'|sed 's/ /\\n/g')

         if [[ $begin -eq 1 ]]; then
            CERTS_TXT=("${CERTS_TXT[@]}"  "${BEGIN_CERT}\\n${temp_txt::-4}\\n${END_CERT}")
         else
            CERTS_TXT=("${CERTS_TXT[@]}"  "\\n${BEGIN_CERT}\\n${temp_txt::-4}\\n${END_CERT}")
         fi

         begin=$(($i+1))
    done
else
     single_cert=$(cat ${CERT_FILE})
     temp_txt=$(echo $single_cert|awk '{$1=$2="";$0=$0;$1=$1;$(NF-1)=$(NF)=""}1'|sed 's/ /\\n/g')
     CERTS_TXT=("${CERTS_TXT[@]}"  "${BEGIN_CERT}\\n${temp_txt::-4}\\n${END_CERT}")
fi


## Formatted private key
private_key=$(cat ${PRIVATE_KEY_FILE})
if [[ z$(grep RSA ${PRIVATE_KEY_FILE}) != "z" ]]; then
   temp_txt=$(echo $private_key|awk '{$1=$2=$3=$4="";$0=$0;$1=$1;$(NF-3)=$(NF-2)=$(NF-1)=$(NF)=""}1'|sed 's/ /\\n/g')
   PRIVATE_KEY_TXT=("${PRIVATE_KEY_TXT[@]}"  "${BEGIN_RSA_PRIVATE_KEY}\\n${temp_txt::-8}\\n${END_RSA_PRIVATE_KEY}")
   echo "TEST : ${PRIVATE_KEY_TXT[@]}"
else
   temp_txt=$(echo $private_key|awk '{$1=$2=$3="";$0=$0;$1=$1;$(NF-2)=$(NF-1)=$(NF)=""}1'|sed 's/ /\\n/g')
   PRIVATE_KEY_TXT=("${PRIVATE_KEY_TXT[@]}"  "${BEGIN_PRIVATE_KEY}\\n${temp_txt::-6}\\n${END_PRIVATE_KEY}")
fi


## Formatted ca cert
ca_cert=$(cat ${CA_CERT_FILE})
temp_txt=$(echo $ca_cert|awk '{$1=$2="";$0=$0;$1=$1;$(NF-1)=$(NF)=""}1'|sed 's/ /\\n/g')
CA_CERT_TXT=("${CA_CERT_TXT[@]}"  "${BEGIN_CERT}\\n${temp_txt::-4}\\n${END_CERT}")

## Call function to create json file
generate_route_json


## Create Route
echo " Execute 'oc create -f ./${HOST_NAME}-route.json'"

