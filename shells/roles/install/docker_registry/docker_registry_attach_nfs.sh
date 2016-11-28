#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Attach NFS to docker registry 
# Config file: ose_config.sh


. $CONFIG_PATH/ose_config.sh

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then
  oc volume deploymentconfigs/docker-registry --add --overwrite --name=registry-storage  --mount-path=/registry --source="{\"nfs\": { \"server\": \"${NFS_SERVER}\",\"path\":   \"${NFS_MOUNT_POINT}/${docker_registry_nfs_mount_point}\"}}"

   oc get -o yaml svc docker-registry |  sed 's/\(sessionAffinity:\s*\).*/\1ClientIP/' |  oc replace -f -

elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; then

#   ssh -q -t root@${ose_cli_operation_vm} " oc volume deploymentconfigs/docker-registry --add --overwrite --name=registry-storage  --mount-path=/registry --source='{\"nfs\": { \"server\": \""${NFS_SERVER}"\",\"path\": \""${NFS_MOUNT_POINT}/${docker_registry_nfs_mount_point}\"}}'"
   
#   ssh -q -t root@${ose_cli_operation_vm} "oc get -o yaml svc docker-registry |  sed 's/\(sessionAffinity:\s*\).*/\1ClientIP/' |  oc replace -f -"

cat << EOF > ./docker_registry_attach_nfs_remote.sh
oc volume deploymentconfigs/docker-registry --add --overwrite --name=registry-storage  --mount-path=/registry --source="{\"nfs\": { \"server\": \""${NFS_SERVER}"\",\"path\":      \"${NFS_MOUNT_POINT}/${docker_registry_nfs_mount_point}\"}}"

    oc get -o yaml svc docker-registry |  sed 's/\(sessionAffinity:\s*\).*/\1ClientIP/' |  oc replace -f -

EOF

scp ./docker_registry_attach_nfs_remote.sh ${con_user}@${ose_cli_operation_vm}:${ose_temp_dir}/.
ssh ${con_user}@${ose_cli_operation_vm} "sh ${ose_temp_dir}/docker_registry_attach_nfs_remote.sh"

mv docker_registry_attach_nfs_remote.sh docker_registry_attach_nfs_remote.sh.bak

else
  echo "This script is designed to execute on master server "
fi
