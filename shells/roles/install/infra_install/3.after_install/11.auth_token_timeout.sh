#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.16
# Purpose:  Minimize authorizationToken timeout
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho  update comment
#
#
#

. ${CONFIG_PATH}/ose_config.sh

for HOST in `egrep "${master_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do
 ssh -q root@$HOST "sed -i -e 's/authorizeTokenMaxAgeSeconds: 500/authorizeTokenMaxAgeSeconds: 60/g' /etc/origin/master/master-config.yaml; systemctl restart atomic-openshift-master-api"
done
