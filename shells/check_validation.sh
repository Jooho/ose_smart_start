. ./ose_config.sh 
password=redhat
echo $all_ip
for node in $all_hosts
do
  echo " "
  echo "Validate $node"
  echo " "
  #sshpass -p $password ssh root@$node "cd /root/shell/validation/pure_vm_check; ./validation_dns_lookup.sh "
  #sshpass -p $password ssh root@$node "cd /root/shell/validation/pure_vm_check; ./validation_yum_repolist.sh "
  #sshpass -p $password ssh root@$node "cd /root/shell/validation/pure_vm_check; ./validation_internet_git_access.sh "
  sshpass -p $password ssh root@$node "cd /root/shell/validation/pure_vm_check; ./validation_persistent_vol.sh"

  #read
done

