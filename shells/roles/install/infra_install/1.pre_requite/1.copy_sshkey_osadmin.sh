#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: Copy ssh key to each VM in the cluster.
#          This script allow linux jump host access to every VM without requiring password.
#          Copy non-root user ssh key to all environment because the environment does not allow to connect with root user at first. 
#
# History:
#          Date      |   Changes
#========================================================================
#        20160711        update comment
#
#
#

. $CONFIG_PATH/ose_config.sh

# Check if id_rsa.pub file exist. If not, it will be generated. 
if [ ! -f ~/.ssh/id_rsa.pub ]; 
then 
	echo | ssh-keygen -b2048 -trsa -N ''
fi


# Be prepared to enter the oseadmin password when sudo requests it
# os3@dm1n

# Copy ssh key 
for HOST in `cat  ${host_file_path}/${host_file} | awk '{ print $1 }'`
do
	ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ${con_user}@$HOST
done


# Test ssh connection establishment without password
for HOST in `cat  ${host_file_path}/${host_file} | awk '{ print $1 }'`
do 
	ssh -q ${con_user}@$HOST "uptime"
done
