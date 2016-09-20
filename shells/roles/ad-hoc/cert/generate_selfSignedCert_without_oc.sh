#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.09.19
# Purpose: This script generate crt/private key which is signed by specific ca.crt file.
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160919   jooho   Create
#
#
#

#. $CONFIG_PATH/ose_config.sh


usage() {
  echo ""
  echo "Usage"
  echo ""
  echo "$0 <HOST_NAME> <SIGNER_KEY> <SIGNER_CERT> <SIGNER_SERIAL>"
  echo "$0 helloworld.cloudapps.example.com  /etc/origin/master/ca.key /etc/origin/master/ca.crt /etc/origin/master/ca.serial.txt"
  echo "$0 helloworld.cloudapps.example.com  ./ca.key ./ca.crt ./ca.serial.txt"
  echo ""
  echo "Note: $0 has sample output"
  if [[ -n $ERR ]]
  then
    echo ""
    echo "ERROR:  ${ERR}"
  fi
  exit 9
}
if [ $# -ne 4 ]
then
  usage
fi



export HOST_NAME=$1
export PRIVATE_KEY_FILE=$2
export CA_CERT_FILE=$3
export SERIAL_FILE=$4


# Create Self Signed Cert and Route

## Create CSR/PRIVATE Key
#echo " Create RSA Private Key "
#openssl genrsa  -out ${HOST_NAME}.key 2048

echo " Create CSR/PRIVATE Key "
openssl req -new -newkey rsa:2048 -nodes -out ${HOST_NAME}.csr -keyout ${HOST_NAME}.key -subj "/C=US/ST=North Carolina/L=Raleigh/O=Red Hat/OU=PaaS Practics/CN=${HOST_NAME}"
#openssl req -new  -nodes -out ${HOST_NAME}.csr -key ${HOST_NAME}.key -subj "/C=US/ST=North Carolina/L=Raleigh/O=Red Hat/OU=PaaS Practics/CN=${HOST_NAME}"

## Create CRT file
echo " Create CRT file"
openssl x509 -req -in ${HOST_NAME}.csr  -CA ${CA_CERT_FILE} -CAkey ${PRIVATE_KEY_FILE} -CAserial ${SERIAL_FILE} -out ${HOST_NAME}.crt -days 500


echo " Creating "
echo " ======================================================== "
echo "  COMMONNAME:     ${HOST_NAME}"
echo "         CRT:     ${HOST_NAME}.crt
echo "         KEY:     ${HOST_NAME}.key
