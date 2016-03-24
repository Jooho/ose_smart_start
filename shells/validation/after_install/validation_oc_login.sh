. ../../ose_config.sh

if [[ $(hostname) == ${ansible_operation_vm} ]]; then
  echo "Add group docker "
  groupadd docker
  echo "Add user joep"
  useradd -G docker joe
  lb_domain=$(grep openshift_master_cluster_public_hostname /etc/ansible/hosts | grep -v ^# |cut -d"=" -f2)

  login_result=$(oc login https://$lb_domain:8443 -u joe -p redhat)

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

