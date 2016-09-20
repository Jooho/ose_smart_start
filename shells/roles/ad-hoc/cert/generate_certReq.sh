#/bin/bash
#
# @(#)$Id$
#
# Purpose:  to create a csr and key for a particular URI
#  Author:  jradtke@redhat.com
#    Date:  20160517
#  NOTICE :
#
#  Example actual command to create csr file to request certificate signed by client:
# openssl req -new -newkey rsa:2048 -nodes -out api_sbx_cloudapps_ao_dcn.csr -keyout api_sbx_cloudapps_ao_dcn.key -subj
# "/C=US/ST=District of Columbia/L=Washington/O=Red Hat/OU=Red Hat/CN=api.sbx.cloudapps.ao.dcn"
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho   update checking for star which is wildcard certificate.

overview() {
echo ""
echo " Creating "
echo " ======================================================== "
echo "  COMMONNAME:     ${COMMONNAME}"
echo "         CSR:     $CSR"
echo "         KEY:     $KEY"
}

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
DOMAIN=cloudapps.ao.dcn
COMMONNAME="${HOST}.${ENV}.${DOMAIN}"
FILENAME="${HOST}.${ENV}.${DOMAIN}"

if [ ${HOST} == "star" ]
then
   COMMONNAME=*.${ENV}.${DOMAIN}
elif [[ ${HOST} == "uniq" ]]
then
   COMMONNAME=${ENV}
   FILENAME=${ENV}
fi

BASENAME=`echo ${FILENAME} | sed 's/\./_/g'`
CSR="${BASENAME}.csr"
KEY="${BASENAME}.key"

if [ -f $KEY ]
then
  ERR="Whoa... file $KEY already exists"
  usage
fi

echo ""
echo " Creating "
echo " ======================================================== "
echo "  COMMONNAME:     ${COMMONNAME}"
echo "         CSR:     $CSR"
echo "         KEY:     $KEY"



# This one liner is all you need
openssl req -new -newkey rsa:2048 -nodes -out ${CSR} -keyout ${KEY} -subj "/C=US/ST=District of Columbia/L=Washington/O=Red Hat/OU=Red Hat/CN=${COMMONNAME}"
echo "If you wish to review your CSR:"
echo "openssl req -text -noout -in ${CSR}"
echo "please keep key/csr file in gitlab repository"
exit 0

