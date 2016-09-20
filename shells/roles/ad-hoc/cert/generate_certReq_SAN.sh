#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Generate private key/csr file/crt file(Self Signed Certificate)
#
# Config file : $CONFIG_PATH/cert_config.sh
#               The CN will looks like : ${COMMONNAME}
#               Example : healthcheck-https.pnp.cloudapps.ao.dcn
#                         (${env} and ${subdomain} are in ose_config.sh)
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho  update comment
#
#
#

usage() {
  echo ""
  echo "Usage"
  echo "$0 <CertObj> <ENV|HOSTNAME>"
  echo "$0 api pnp  ==> api.pnp.cloudapps.ao.dcn"
  echo "$0 star pnp ==> *.pnp.cloudapps.ao.dcn"
  echo "$0 uniq sourcehub.ao.dcn ==> sourcehub.ao.dcn"
  if [[ -n $ERR ]]
  then
    echo ""
    echo "ERROR:  ${ERR}"
  fi
  exit 9
}
if [ $# -ne 2 ]
then
  usage
fi

HOST=${1}
ENV=${2}
DOMAIN=cloudapps.example.com
COMMONNAME="${HOST}.${ENV}.${DOMAIN}"
FILENAME="${HOST}.${ENV}.${DOMAIN}"





cat << EOF > ${COMMONNAME}.openssl-conf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = US
countryName_default = US
stateOrProvinceName = District of Columbia 
stateOrProvinceName_default = District of Columbia 
localityName = Washington
localityName_default = Washington
organizationName = Red Hat
organizationName_default = Red Hat
organizationalUnitName = PaaS Practice
organizationalUnitName_default = PaaS Practice
commonName = ${COMMONNAME}
commonName_default = ${COMMONNAME}
commonName_max  = 64

emailAddress = ose_pilot@redhat.com
emailAddress_default = ose_pilot@redhat.com

[req_attributes]
challengePasssword	= 'RedH@tOs3'

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${COMMONNAME}
DNS.2 = master1.example.com
DNS.3 = master2.example.com
DNS.4 = master3.example.com
EOF

if [[ -e ${COMMONNAME}.key ]] || [[ -e ${COMMONNAME}.csr ]] || [[ -e ${COMMONNAME}.crt ]]; then
  echo "There are already generaged files so please check it first.. don't want to mess up"
  exit 9
else
  openssl genrsa -out ${COMMONNAME}.key 2048
  openssl req -new -out ${COMMONNAME}.csr -key ${COMMONNAME}.key -config ${COMMONNAME}.openssl-conf
  openssl req -text -noout -in ${COMMONNAME}.csr
  openssl x509 -req -days 3650 -in ${COMMONNAME}.csr -signkey ${COMMONNAME}.key -out ${COMMONNAME}.crt -extensions v3_req -extfile ${COMMONNAME}.openssl-conf

  exit 0
fi
