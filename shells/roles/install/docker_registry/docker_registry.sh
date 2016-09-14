#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Deploy docker registry on ${infra_selector}
# Config file: ose_config.sh

. $CONFIG_PATH/ose_config.sh

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then

oadm registry --service-account=registry --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --selector="${infra_selector}"

elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; then
#ssh -q -t root@${ose_cli_operation_vm} "oadm registry --service-account=registry --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --selector=\"${infra_selector}\""
cat << EOF > ./docker_registry_remote.sh

oadm registry --service-account=registry --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-\${component}:\${version}' --selector="${infra_selector}"

EOF

scp ./docker_registry_remote.sh ${con_user}@${ose_cli_operation_vm}:${ose_temp_dir}/.
ssh ${con_user}@${ose_cli_operation_vm} "sh ${ose_temp_dir}/docker_registry_remote.sh"

mv docker_registry_remote.sh docker_registry_remote.sh.bak

else
  echo "This script is designed to execute on master server"
fi
