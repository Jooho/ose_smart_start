. ../ose_config.sh

CA=/etc/origin/master
subdomain=$(grep subdomain /etc/origin/master/master-config.yaml | grep -v ^# |cut -d":" -f2|sed 's/"//g'| xargs)

# Create SSL pem file using default ca file for router. 
echo "Created cloudapps. file : $CA/router.key , $CA/router.crt"
oadm ca create-server-cert --signer-cert=$CA/ca.crt  --signer-key=$CA/ca.key --signer-serial=$CA/ca.serial.txt --hostnames='${subdomain}'  --cert=$CA/router.crt --key=$CA/router.key

echo "Create SSL pem file using default ca file for router : $CA/router.pem"
cat router.crt router.key $CA/ca.crt > $CA/router.pem

oadm router --replicas=1 --default-cert=$CA/router.pem --credentials='/etc/origin/master/openshift-router.kubeconfig' --service-account=router --selector=${infra_selector}
