#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Expose docker registry service and create cert folder

. $CONFIG_PATH/ose_config.sh

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then

cat << EOF > docker_registry_route.yaml
apiVersion: v1
kind: Route
metadata:
  name: registry
spec:
  host: ${docker_registry_route_url}
  to:
    kind: Service
    name: docker-registry
  tls:
    termination: passthrough

EOF

oc create -f ./docker_registry_route.yaml
#rm -rf docker_registry_route.yaml

elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; then

cat << EOA > docker_registry_expose_remote.sh
cat << EOB > docker_registry_route.yaml
apiVersion: v1
kind: Route
metadata:
  name: registry
spec:
  host: ${docker_registry_route_url}
  to:
    kind: Service
    name: docker-registry
  tls:
    termination: passthrough

EOB

. ${CONFIG_PATH}/ose_config.sh
oc create -f ./docker_registry_route.yaml
#rm -rf docker_registry_route.yaml

CA=/etc/origin/master
cp \$CA/ca.crt \${ose_temp_dir}/.
chmod 777 \${ose_temp_dir}/ca.crt

EOA

scp ./docker_registry_expose_remote.sh  ${con_user}@${ose_cli_operation_vm}:${ose_temp_dir}/.
ssh -q -t ${con_user}@${ose_cli_operation_vm} "/usr/bin/sudo su - -c \"sh ${ose_temp_dir}/docker_registry_expose_remote.sh\""




mv docker_registry_expose_remote.sh docker_registry_expose_remote.sh.bak

else
    echo "This script is designed to execute on master server"
fi


for ip in ${all_ip};
do
  scp ./ca.crt ${con_user}@$ip:${ose_temp_dir}/.
  ssh -q -t ${con_user}@$ip "sudo mkdir -p /etc/docker/certs.d/${docker_registry_route_url}; sudo cp ${ose_temp_dir}/ca.crt /etc/docker/certs.d/${docker_registry_route_url}"

done



