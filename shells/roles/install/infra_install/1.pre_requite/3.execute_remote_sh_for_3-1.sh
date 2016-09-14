#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: This script help copy ssh key and modify ssh configuration which allow root user to connect directly
#
# History:
#          Date      |   Changes
#========================================================================
#        20160711        update comment
#
#
#


# Included scripts:
#
#  - 3-1.change_ssh_conf_allow_root_user.sh 
#   Description :
#       Change ssh configuration to allow root user to be accessible
#   Execute Host :
#       All VMs
##############################################################################

. $CONFIG_PATH/ose_config.sh


# Execute #2 script on each vm
for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $2 }'`; 
do 
	ssh ${HOST} -t "/usr/bin/sudo ${ose_temp_dir}/${pre_requite_path}/3-1.change_ssh_conf_allow_root_user.sh" ; 
done

if [[ $enable_sudo == true ]]; then
# Now test - you should no longer need a password
echo "***check if sudo works***"
for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $1 }'`
do
	ssh -q -t ${con_user}@${HOST} '/usr/bin/sudo su - -c "grep ${con_user} /etc/shadow"' 
done

echo ""
fi

echo "***check if root user can access****"
for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $1 }'`
do 
	ssh -q -t root@${HOST} "grep ${con_user} /etc/shadow"
done

