. ../../config/ose_config.sh

mkdir ./docker-registry-ca

cd ./docker-registry-ca

CA=/etc/origin/master
oadm ca create-server-cert --signer-cert=$CA/ca.crt \
    --signer-key=$CA/ca.key --signer-serial=$CA/ca.serial.txt \
    --hostnames='docker-registry.default.svc.cluster.local,${docker_registry_svc_ip},${docker_registry_route_url}' \
    --cert=registry.crt --key=registry.key

oc delete secrets  registry-secret
#oc secrets remove serviceaccounts/default secrets/registry-secret
echo "if you don't want to use ssl at all, you need to delete secrets/registry-secret in sa/default by manually"

 oc volume dc/docker-registry --remove --name=docker-secrets \

oc env dc/docker-registry -e \
    REGISTRY_HTTP_TLS_CERTIFICATE=/etc/secrets/registry.crt -e\
    REGISTRY_HTTP_TLS_KEY=/etc/secrets/registry.key

oc patch dc/docker-registry --api-version=v1 -p '{"spec": {"template": {"spec": {"containers":[{
    "name":"registry",
    "livenessProbe":  {"httpGet": {"scheme":"HTTP"}}
  }]}}}}'
    

sudo rm -rf /etc/docker/certs.d/${docker_registry_svc_ip}:5000

sudo rm -rf /etc/docker/certs.d/docker-registry.default.svc.cluster.local:5000


