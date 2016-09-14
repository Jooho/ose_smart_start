. $CONFIG_PATH/ose_config.sh


create_route_file(){


cat < EOF >> ${HOSTNAME}

}



usage() {
  echo ""
  echo "Usage"
  echo "$0 <CertPATH> <HOSTNAME>"
  echo "$0 /etc/origin/master/ca.crt  test.pnp.cloudapps.ao.dcn"
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

export CERT=${1}
export HOSTNAME=${2}




# Create SSL pem file using default ca file for router.
echo "Created crt/private key signed by $CERT"
echo "oadm ca create-server-cert --signer-cert=$CA/ca.crt  --signer-key=$CA/ca.key --signer-serial=$CA/ca.serial.txt --hostnames=\"${hostname}\"  --cert=${HOSTNAME}.crt --key=${HOSTNAME}.key"
#oadm ca create-server-cert --signer-cert=$CA/ca.crt  --signer-key=$CA/ca.key --signer-serial=$CA/ca.serial.txt --hostnames=\"${hostname}\"  --cert=${HOSTNAME}.crt --key=${HOSTNAME}.key

openssl req -new -newkey rsa:2048 -nodes -out ${CSR} -keyout ${KEY} -subj "/C=US/ST=District of Columbia/L=Washington/O=Administrative Office of the United States Courts/OU=Administrative Office of the United States Courts/CN=${COMMONNAME}"

echo "Create edge tls route using the generated crt/private key : ${HOSTNAME}-route.json"


