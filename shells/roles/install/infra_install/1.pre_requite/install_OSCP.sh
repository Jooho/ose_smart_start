#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: This script install atomic-openshift-utils package on linux jump host
#          Then, show the installation command instead of automatic execution.
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho   create
#
#
#

. $CONFIG_PATH/ose_config.sh

# Install ansible package which is conainted atomic-openshift-utils package.
sudo yum install atomic-openshift-utils -y

# Mark sure that host keys are working before you start the Ansible playbook
cat << EOF > ~/.ansible.cfg
[defaults]
log_path=~/.ansible.log
EOF

# Last Check before install Openshift Container Platform
for HOST in `cat ${host_file_path}/${host_file} | awk '{ print $1 }'`
do 
	ssh -q root@$HOST "uptime"
done

ls ${ansible_file_path}/${ansible_hosts}

################### Install OSE !!!!!    ##################
echo " "
echo "Now we are ready to install Openshift, please execute this command"
echo "ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml -i ${ansible_file_path}/${ansible_hosts}"

