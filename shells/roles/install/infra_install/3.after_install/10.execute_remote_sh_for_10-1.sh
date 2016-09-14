#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Expose docker registry service and create cert folder
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  parameterized variables
#
#
#

. $CONFIG_PATH/ose_config.sh

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then

   ./10-1.expose_docker_registry.sh

elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]];
then

    ssh ${ose_cli_operation_vm} "sh ${ose_temp_dir}/${after_install_path}/10-1.expose_docker_registry.sh"

fi


CA=/etc/origin/master

for host in ${all_hosts}
do
  ssh root@$host "sudo mkdir -p /etc/docker/certs.d/${docker_registry_route_url}"
  scp $CA/ca.crt root@$host:/etc/docker/certs.d/${docker_registry_route_url}/.
done

