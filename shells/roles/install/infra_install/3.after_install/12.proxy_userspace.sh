#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.14
# Purpose: Change proxy mode to userspace
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho  Created
#
#
#

. ${CONFIG_PATH}/ose_config.sh

for HOST in `egrep "${node_prefix}" ${host_file_path}/${host_file} | awk '{ print $1 }' `
do
 ssh -q root@$HOST "sed -i -e 's/iptables/userspace/g' /etc/origin/node/node-config.yaml; systemctl restart atomic-openshift-node"
done
