. ../../ose_config.sh

if [[ $(hostname) == ${ansible_operation_vm} ]]; then
  subdomain=$(grep osm_default_subdomain /etc/ansible/hosts | cut -d"=" -f2)

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

