#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.14
# Purpose: This script help execute remote shell.
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  create
#
#
#

# Included scripts:
#
#   1-1.install_stunnel.sh 
#   Description :
#        Explain how to implement Secure LDAP using a non-TLS tunnel
#   Execute Host :
#        Masters/Infra Nodes
#
#   1-2.config_master-config.sh
#   Description :
#        Update master-config.yaml for LDAP authentication
#   Execute Host :
#        Masters
##############################################################################

. $CONFIG_PATH/ose_config.sh

for HOST in `egrep "${master_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do
	ssh -q root@${HOST} "sh ${ose_temp_dir}/${after_install_path}/1-1.install_stunnel.sh
done


for HOST in `egrep "${infra_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do
	ssh -q root@${HOST} "sh ${ose_temp_dir}/${after_install_path}/1-1.install_stunnel.sh
done


for HOST in `egrep "${master_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do
        ssh -q root@${HOST} "sh ${ose_temp_dir}/${after_install_path}/1-2.config_master-config.sh
done





 
