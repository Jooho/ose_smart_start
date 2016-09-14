#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Generate private key/csr file/crt file(Self Signed Certificate)
#
# Config file : $CONFIG_PATH/cert_config.sh
#               The CN will looks like : ${host}.${env}.${subdomain}
#               Example : healthcheck-https.pnp.cloudapps.ao.dcn
#                         (${env} and ${subdomain} are in ose_config.sh)
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho  update comment
#
#
#



cat << EOF > ${host}.${env}.${subdomain}.openssl-conf
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
organizationName = Administrative Office of the United States Courts
organizationName_default = Administrative Office of the United States Courts
organizationalUnitName = AOUSC
organizationalUnitName_default = AOUSC
commonName = ${host}.${env}.${subdomain}
commonName_default = ${host}.${env}.${subdomain}
commonName_max  = 64

emailAddress = ose_pilot@ao.uscourts.gov
emailAddress_default = ose_pilot@ao.uscourts.gov

[req_attributes]
challengePasssword	= 'RedH@tOs3'

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${host}.${env}.${subdomain}
DNS.2 = aoappd-e-mgt004.ctho.asbn.gtwy.dcn
DNS.3 = aoappd-e-mgt005.ctho.asbn.gtwy.dcn
DNS.4 = aoappd-e-mgt006.ctho.asbn.gtwy.dcn
EOF

if [[ -e ${host}.${env}.${subdomain}.key ]] || [[ -e ${host}.${env}.${subdomain}.csr ]] || [[ -e ${host}.${env}.${subdomain}.crt ]]; then
  echo "There are already generaged files so please check it first.. don't want to mess up"
  exit 9
else
  openssl genrsa -out ${host}.${env}.${subdomain}.key 2048
  openssl req -new -out ${host}.${env}.${subdomain}.csr -key ${host}.${env}.${subdomain}.key -config ${host}.${env}.${subdomain}.openssl-conf
  openssl req -text -noout -in ${host}.${env}.${subdomain}.csr
  openssl x509 -req -days 3650 -in ${host}.${env}.${subdomain}.csr -signkey ${host}.${env}.${subdomain}.key -out ${host}.${env}.${subdomain}.crt -extensions v3_req -extfile ${host}.${env}.${subdomain}.openssl-conf

  exit 0
fi
