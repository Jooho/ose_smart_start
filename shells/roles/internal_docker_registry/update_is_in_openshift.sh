#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.08.17
# Purpose: This script update ImageStrem in openshift project
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160817   jooho  Create
#
#
#
##############################################################################

. $CONFIG_PATH/ose_config.sh


for is in $(oc get is -n openshift |awk '{print $1}')
do
   oc import-image $is -n openshift
done
