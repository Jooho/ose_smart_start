#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.08.18
# Purpose: This script help execute commands on remote vm
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160818   jooho  Create
#
#
#

# Usage :
#     $0 'commands'i              (all vms)
#     $0 'commands' 'indicator'   (specific vms)
#
#  ex) $0 'sudo service docker restart'                 (all vms) 
#      $0 'sudo service atomic-openshift-node'  nde     (all nodes which hostname contains nde)
#      $0 'sudo service atomic-openshift-node'  nde002  (only nde002 server)
#
##############################################################################

. ${CONFIG_PATH}/ose_config.sh

password=redhat
echo $all_hosts
for node in $all_hosts
do
  echo " "
  echo "Execute commands on $node"
  echo " "
  if [[  z$2 == z ]]; then
     ssh -q -t ${con_user}@$node "$1"
  else
     if [[ $node =~ $2 ]]; then
       ssh -q -t ${con_user}@$node "$1"
     fi
  fi
done

