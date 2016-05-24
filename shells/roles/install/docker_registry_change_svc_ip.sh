#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Change docker registry service ip 
# Config file: ose_config.sh


#  Set a Predefined IP for the registry

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]¬
then¬

	TMPFILE=$(mktemp)

	oc get svc docker-registry -n default -o yaml | sed -re "/(cluster|portal)IP:/s/:\s+[0-9.]+$/: ${docker_registry_svc_ip}/" >
	$TMPFILE || exit 1
	
	# Have to use delete/create since IP address is immutable attribute
	oc delete svc docker-registry -n default
	oc create -f $TMPFILE

	rm -f $TMPFILE

elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; then

cat << EOF > ./docker_registry_change_svc_ip.sh
    TMPFILE=$(mktemp)

    oc get svc docker-registry -n default -o yaml | sed -re "/(cluster|portal)IP:/s/:\s+[0-9.]+$/: ${docker_registry_svc_ip}/" >
    $TMPFILE || exit 1

    # Have to use delete/create since IP address is immutable attribute
    oc delete svc docker-registry -n default
    oc create -f $TMPFILE

    rm -f $TMPFILE
EOF

scp ./docker_registry_change_svc_ip_remote.sh root@${HOST}:${ose_temp_dir}/.
ssh root@${HOST} "sh ${ose_temp_dir}/docker_registry_change_svc_ip_remote.sh"

mv docker_registry_change_svc_ip_remote.sh docker_registry_change_svc_ip_remote.sh.bak

else
	  echo "This script is designed to execute on master server"
fi

for HOST in ${all_hosts}
do
    if [[ $HOST =~ ${master_prefix} ]]; then
	  echo "Restarting master server : $HOST"
	  ssh -q root@$HOST "systemctl restart atomic-openshift-master-api"
    fi
done
