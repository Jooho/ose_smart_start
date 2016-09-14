#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: This script execute remote shell 
# History:
#          Date      |   Changes
#========================================================================
#        20160711        update comment
#
#
#

# Included scripts:
#
#  - 4-1.satellite_subscription.sh
#   Description :
#       This script will install katello-package and try to register host to satellite using subscription-manger 
#   Execute Host:
#       All VMs
##############################################################################

. $CONFIG_PATH/ose_config.sh


####################### Subscribe hosts to Satellite 6 ##############
for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $2 }'`
do
	ssh -q root@${HOST} "sh ${ose_temp_dir}/${pre_requite_path}/4-1.satellite_subscription.sh" 
done

