#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
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
#  - 5-1.install_essential_packages.sh
#   Description :
#       Install essential packages : wget git net-tools bind-utils iptables-services bridge-utils bash-completion nfs-utils nmap
#       Update packages
#   Execute Host :
#       All VMs
##############################################################################

. $CONFIG_PATH/ose_config.sh

for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $2 }'`
do
        echo "ssh -q root@${HOST} sh ${ose_temp_dir}/${pre_requite_path}/5-1.install_essential_packages.sh"
        ssh -q root@${HOST} "sh ${ose_temp_dir}/${pre_requite_path}/5-1.install_essential_packages.sh"
done




 
