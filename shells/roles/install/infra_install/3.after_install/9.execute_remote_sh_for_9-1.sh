#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: This script help execute remote shell
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   update comments
#
#
#

# Included scripts:
#
#  - 9-1.config_rsyslog_logrotate.sh
#   Description :
#      Redirect logs which contains specific word "openshift" and "docker" to file
#   Execute Host:
#        All VMs except ETCD nodes.

. $CONFIG_PATH/ose_config.sh

for HOST in `egrep -v "${etcd_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do
   ssh -q root@$HOST "sh ${ose_temp_dir}/${after_install_path}/9-1.config_fsyslog_logrotate.sh"
done
