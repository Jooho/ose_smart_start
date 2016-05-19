. ../../config/ose_config.sh

mkdir ./docker-registry-ca

cd ./docker-registry-ca

export docker_registry_svc_ip=$(oc get svc docker-registry|grep 172 |awk '{print $2}')
CA=/etc/origin/master
oadm ca create-server-cert --signer-cert=$CA/ca.crt \
    --signer-key=$CA/ca.key --signer-serial=$CA/ca.serial.txt \
    --hostnames="docker-registry.default.svc.cluster.local,${docker_registry_svc_ip},${docker_registry_route_url}" \
    --cert=registry.crt --key=registry.key

oc delete secrets registry-secret

oc secrets new registry-secret registry.crt registry.key


oc secrets add serviceaccounts/default secrets/registry-secret

 oc volume dc/docker-registry --add --type=secret --name=docker-secrets\
    --secret-name=registry-secret -m /etc/secrets

oc env dc/docker-registry \
    REGISTRY_HTTP_TLS_CERTIFICATE=/etc/secrets/registry.crt \
    REGISTRY_HTTP_TLS_KEY=/etc/secrets/registry.key

oc patch dc/docker-registry --api-version=v1 -p '{"spec": {"template": {"spec": {"containers":[{
    "name":"registry",
    "livenessProbe":  {"httpGet": {"scheme":"HTTPS"}}
  }]}}}}'

echo "Copy ca.crt to /etc/docker/cert.d/[${docker_registry_svc_ip},docker-registry.default.svc.cluster.local]"

for ip in ${all_ip}; 
do 
  sshpass -p $password ssh root@$ip "sudo mkdir -p /etc/docker/certs.d/${docker_registry_svc_ip}:5000"
  sshpass -p $password scp $CA/ca.crt root@$ip:/etc/docker/certs.d/${docker_registry_svc_ip}:5000/


  sshpass -p $password ssh root@$ip "sudo mkdir -p /etc/docker/certs.d/docker-registry.default.svc.cluster.local:5000"
  sshpass -p $password scp $CA/ca.crt root@$ip:/etc/docker/certs.d/docker-registry.default.svc.cluster.local:5000/.

done
echo "Now, delete --insecure-registry option from /etc/sysconfig/docker"
echo "then execute following:"
echo "$ sudo systemctl daemon-reload; sudo systemctl restart docker"

