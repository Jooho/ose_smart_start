. ./ose_config.sh 
password=redhat
echo $all_ip
for node in $all_hosts
do
  echo " "
  echo "Test DNS on $node"
  echo " "
  #sshpass -p $password ssh root@$node "cd /root/shell/validation/pure_vm_check; ./validation_dns_lookup.sh "
  sshpass -p $password ssh root@$node "cd /root/shell/validation/pure_vm_check; ./validation_yum_repolist.sh "

  read
done

