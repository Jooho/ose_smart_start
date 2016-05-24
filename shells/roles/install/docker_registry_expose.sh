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

oc create -f ./docker_registry_route.yaml
#rm -rf docker_registry_route.yaml
EOA

scp ./docker_registry_expose_remote_remote.sh root@${HOST}:${ose_temp_dir}/.
ssh root@${HOST} "sh ${ose_temp_dir}/docker_registry_expose_remote_remote.sh"

mv docker_registry_expose_remote_remote.sh docker_registry_expose_remote_remote.sh.bak

else
    echo "This script is designed to execute on master server"
fi

CA=/etc/origin/master

for host in ${all_hosts};
do
  sshpass -p $password ssh root@$host "sudo mkdir -p /etc/docker/certs.d/${docker_registry_route_url}:5000"
  sshpass -p $password scp $CA/ca.crt root@$host:/etc/docker/certs.d/${docker_registry_route_url}:5000/.
done

