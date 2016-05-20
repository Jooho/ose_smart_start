#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.20
# Purpose: Check if api server is working well


. $CONFIG_PATH/ose_config.sh

if [[ $(hostname) == ${ansible_operation_vm} ]]; then
  echo "Add group docker "
  groupadd docker
  echo "Add user joep"
  useradd -G docker joe

  lb_domain=$openshift_master_cluster_public_hostname

  login_result=$(runuser -l joe -c "oc login https://$lb_domain:8443 -u joe -p redhat --insecure-skip-tls-verify=true")

  echo ""
  echo "---------------------------------------------------------- "
  echo "Login to OSE with joe (oc login https://$lb_domain:8443) "
  echo "---------------------------------------------------------- "
  if [[ $login_result =~ "Login successful" ]];then
      echo "** Result >> PASS !!"
  else
      echo "** Result >> FAIL ;("
  fi
fi

