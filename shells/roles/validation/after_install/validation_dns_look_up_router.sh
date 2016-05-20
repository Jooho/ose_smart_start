#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.20
# Purpose: Check if the subdomain can be resolved to point router(infra node)


. $CONFIG_PATH/ose_config.sh

if [[ $(hostname) == ${ansible_operation_vm} ]]; then

  resolve_subdomain=$(dig test.$subdomain |grep ANSWER|awk '{print $10}'|sed 's/,//g')

  echo "---------------------------------------------------------- "
  echo "\"$subdomain\" Subdomain for Router can be resolved by DNS?"
  echo "---------------------------------------------------------- "
  if [[ $resolbe_subdomain != 0 ]];then
      echo "** Result >> PASS !!"
  else
      echo "** Result >> FAIL ;("
  fi
else
  echo "---------------------------------------------- "
  echo " Subdomain for Router can be resolved by DNS?"
  echo "---------------------------------------------- "
  echo "Do not test it intentionally. only ansible executor vm is tested."
fi

