#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Generate self signed certificate with openshift root ca.crt file and apply this cert to docker registry


. $CONFIG_PATH/ose_config.sh

export CA=/etc/origin/master

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then

mkdir ./docker-registry-ca

cd ./docker-registry-ca

export real_docker_registry_svc_ip=$(oc get svc docker-registry|grep 172 |awk '{print $2}')
if [[ $real_docker_registry_svc_ip != $docker_registry_svc_ip ]]; then
  echo " You have to change docker registry service ip to ${docker_registry_svc_ip} before executing this script"
  exit 9
fi

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

##ELSE
elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; then

cat << EOF > ./docker_registry_ssl_remote.sh

. \$CONFIG_PATH/ose_config.sh

mkdir ./docker-registry-ca

cd ./docker-registry-ca

export real_docker_registry_svc_ip=\$(oc get svc docker-registry|grep 172 |awk '{print \$2}')
if [[ \$real_docker_registry_svc_ip != \$docker_registry_svc_ip ]]; then
  echo " You have to change docker registry service ip to ${docker_registry_svc_ip} before executing this script"
  exit 9
fi

CA=/etc/origin/master
oadm ca create-server-cert --signer-cert=\$CA/ca.crt \
    --signer-key=\$CA/ca.key --signer-serial=\$CA/ca.serial.txt \
    --hostnames="docker-registry.default.svc.cluster.local,\${docker_registry_svc_ip},\${docker_registry_route_url}" \
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
    "readinessProbe":  {"httpGet": {"scheme":"HTTPS"}}
  }]}}}}'


EOF

scp ./docker_registry_ssl_remote.sh ${con_user}@${ose_cli_operation_vm}:${ose_temp_dir}/.
ssh ${con_user}@${ose_cli_operation_vm} "sh ${ose_temp_dir}/docker_registry_ssl_remote.sh"

mv docker_registry_ssl_remote.sh docker_registry_ssl_remote.sh.bak

else
  echo "This script is designed to execute on master server"
fi

scp ${ose_cli_operation_vm}:$CA/ca.crt ./

for ip in ${all_ip};
do
  scp ./ca.crt ${con_user}@$ip:${ose_temp_dir}/.
  ssh -q -t ${con_user}@$ip "sudo mkdir -p /etc/docker/certs.d/${docker_registry_svc_ip}:5000; sudo cp ${ose_temp_dir}/ca.crt /etc/docker/certs.d/${docker_registry_svc_ip}:5000/ ;sudo mkdir -p /etc/docker/certs.d/docker-registry.default.svc.cluster.local:5000; sudo cp /${ose_temp_dir}/ca.crt /etc/docker/certs.d/docker-registry.default.svc.cluster.local:5000/"

done

echo "Now, delete --insecure-registry option from /etc/sysconfig/docker"
echo "then execute following:"
echo "$ sudo systemctl daemon-reload; sudo systemctl restart docker"

