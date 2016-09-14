#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Import Fuse Image
# Execute Host :
#       All VMs
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   update comment
#


. ${CONFIG_PATH}/ose_config.sh

if [[ $(hostname) == ${ose_cli_operation_vm} ]] && [[ ${ansible_operation_vm} == ${ose_cli_operation_vm} ]]
then

    echo "oc create -n openshift -f /usr/share/openshift/examples/xpaas-streams/fis-image-streams.json"
    oc create -n openshift -f /usr/share/openshift/examples/xpaas-streams/fis-image-streams.json


elif [[ $(hostname) == ${ansible_operation_vm} ]] && [[ ${ansible_operation_vm} != ${ose_cli_operation_vm} ]]; then
    echo "ssh -q root@${ose_cli_operation_vm} \"oc create -n openshift -f /usr/share/openshift/examples/xpaas-streams/fis-image-streams.json\""
    ssh -q root@${ose_cli_operation_vm} "oc create -n openshift -f /usr/share/openshift/examples/xpaas-streams/fis-image-streams.json"

fi

