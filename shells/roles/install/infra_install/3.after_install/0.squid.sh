#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.02
# Purpose: This script help to install/configure squid
#          Squid is proxy program and it is being used to handle 3 different newtork environment.
#            - Inside Openshift
#            - The Court's internal networks
#            - The internet access
#          The configuration is based on Tim hunt github repo : https://github.com/rhtconsulting/rhc-ose/tree/openshift-enterprise-3/openshift-squid
#          Security Scanning report warning using squid and it is answered : https://cfa-jenie.ao.dcn/confluence/display/OSEP/STG+-+Security+Scanning
# 
#          
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   update comment
#
#
#


# Included scripts:
#
#  - 0-1.install_configure_squid.sh
#   Description :
#       This script install squid package on master/infra nodes and change configuration. Before executing it, you need
#       to update this script according to your environment.
#   Execute Host:
#        master/infra nodes
#
#  - 0-2.add_proxy_information_docker_ose.sh 
#   Description :
#       In order to use proxy server properly, http_proxy/https_proxy/no_proxy information should be updated.
#   Execute Host:
#        All VMs
#
#  - 0-3.create_squid_svc.sh"
#   Description :
#       app nodes point to ose svc for squid because there could be a firewall between compute nodes and proxy. The
#       advantage of using ose svc is that 3128 port is not needed to open on th firewall. 
#   Execute Host:
#        ansible host(jump host)
#
#  - 0-4.create_squid_iptables.sh
#   Description :
#        To access squid from All vms, the hosts that run squid should open 3128 port but this script will be executed
#        on master/compute nodes
#   Execute Host:
#        master/compute nodes


. $CONFIG_PATH/ose_config.sh

#Install Squid to Masters/Infra nodes
for HOST in `egrep "${master_prefix}" ${host_file_path}/${host_file} | awk '{ print $1 }' `
do
    	ssh -q ${HOST} "sh ${ose_temp_dir}/${after_install_path}/0-1.install_configure_squid.sh"
done

for HOST in `egrep "${infra_prefix}" ${host_file_path}/${host_file} | awk '{ print $1 }' `
do
    	ssh -q ${HOST} "sh ${ose_temp_dir}/${after_install_path}/0-1.install_configure_squid.sh"
done


# Update proxy information
for HOST in `grep -v \# ${host_file_path}/$host_file | awk '{ print $1 }'` 
do 
	ssh -q root@${HOST} "sh ${ose_temp_dir}/${after_install_path}/0-2.add_proxy_information_docker_ose.sh" ; 
done


if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then

   ./0-3.create_squid_svc.sh

elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; 
then

    ssh ${ose_cli_operation_vm} "sh ${ose_temp_dir}/${after_install_path}/0-3.create_squid_svc.sh"

fi

# Add iptables
for HOST in `egrep -v "${etcd_prefix}" ${host_file_path}/${host_file} | awk '{ print $1 }' `
do
    ssh -q ${HOST} "sh ${ose_temp_dir}/${after_install_path}/0-4.create_squid_iptables.sh"
done

###### You will need to update the squid configuration and then revisit this section

# Test Proxy access to Red Hat registry
echo " Test Proxy access to Red Hat Registry"

echo "curl -x localhost:3128 https://registry.access.redhat.com/v1/_ping"
curl -x localhost:3128 https://registry.access.redhat.com/v1/_ping
