. ../ose_config.sh

CA=/etc/origin/master

# Create SSL pem file using default ca file for router.
echo "Created cloudapps. file : $CA/router.key , $CA/router.crt  subdomain:$subdomain"
oadm ca create-server-cert --signer-cert=$CA/ca.crt  --signer-key=$CA/ca.key --signer-serial=$CA/ca.serial.txt --hostnames='gitlab.cloudapps.example.com'  --cert=$CA/gitlab.cloudapps.example.com.crt --key=$CA/gitlab.cloudapps.example.com.key
