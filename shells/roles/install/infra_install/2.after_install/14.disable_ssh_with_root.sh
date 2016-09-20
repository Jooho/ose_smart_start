#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.03
# Purpose: Disable to access VMs with root user

. $CONFIG_PATH/ose_config.sh

# Disable root logins (once maintenance is complete)
for HOST in `egrep "${node_prefix}" ${host_file_path}/${host_file} | awk '{ print $1 }' ` 
do
  ssh -qt $HOST "sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config"
done
