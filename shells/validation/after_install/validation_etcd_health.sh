. ../../ose_config.sh


prefix=""
etcd_vm=""


if [[ $(hostname) =~ ${master_prefix} ]]; then
   if [[ $etcd_is_installed_on_master == true ]]; then
      prefix=${master_prefix}    
   else
      prefix=${etcd_prefix}
   fi
   
   for host in $all_hosts
   do
      if [[ $host =~ ${prefix} ]]; then
        if [[ $etcd_vm == "" ]]; then
           etcd_vm="https://$host:2379"
        else
           etcd_vm="$etcd_vm,https://$host:2379"
        fi
      fi
   done
  
   etcd_health_result=$( etcdctl -C \
       $etcd_vm \
       --ca-file=/etc/origin/master/master.etcd-ca.crt \
       --cert-file=/etc/origin/master/master.etcd-client.crt \
       --key-file=/etc/origin/master/master.etcd-client.key cluster-health|grep unreachable| wc -l)

  echo "---------------------------------------------------------- "
  echo "            Clustered etcd health check                    "
  echo "---------------------------------------------------------- "
  if [[ $etcd_health_result == 0 ]];then
      echo "** Result >> PASS !!"
  else
      echo "** Result >> FAIL ;("

      etcdctl -C \
       $etcd_vm \
       --ca-file=/etc/origin/master/master.etcd-ca.crt \
       --cert-file=/etc/origin/master/master.etcd-client.crt \
       --key-file=/etc/origin/master/master.etcd-client.key cluster-health
  fi
fi

