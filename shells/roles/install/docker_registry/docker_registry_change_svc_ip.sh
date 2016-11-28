#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Change docker registry service ip 
# Config file: ose_config.sh

. $CONFIG_PATH/ose_config.sh

#  Set a Predefined IP for the registry
temp_file=exist_docker_registry_svc.yaml

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then

	oc get svc docker-registry -n default -o yaml | sed -re "/(cluster|portal)IP:/s/:\s+[0-9.]+$/: ${docker_registry_svc_ip}/" > $temp_file || exit 1
	
	# Have to use delete/create since IP address is immutable attribute
	oc delete svc docker-registry -n default
	oc create -f $temp_file

	rm -f $TMPFILE

elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; then

cat << EOF > ./docker_registry_change_svc_ip_remote.sh

    oc get svc docker-registry -n default -o yaml | sed -re "/(cluster|portal)IP:/s/:\s+[0-9.]+$/: ${docker_registry_svc_ip}/" > $temp_file || exit 1

    # Have to use delete/create since IP address is immutable attribute
    oc delete svc docker-registry -n default
    oc create -f $temp_file

    rm -f $TMPFILE
EOF

scp ./docker_registry_change_svc_ip_remote.sh ${con_user}@${ose_cli_operation_vm}:${ose_temp_dir}/.
ssh ${con_user}@${ose_cli_operation_vm} "sh ${ose_temp_dir}/docker_registry_change_svc_ip_remote.sh"

mv docker_registry_change_svc_ip_remote.sh docker_registry_change_svc_ip_remote.sh.bak

else
	  echo "This script is designed to execute on master server"
fi

for HOST in ${all_hosts}
do
    if [[ $HOST =~ ${master_prefix} ]]; then
	  echo "Restarting master server : $HOST"
	  ssh -t -q ${con_user}@$HOST "sudo systemctl restart atomic-openshift-master-api"
    fi
done
