. ./ose_config.sh 
password=redhat
echo $all_ip
tar -cvf ../validation.tar ./
for node in $all_hosts
do
  echo " "
  echo "Test DNS on $node"
  echo " "
  sshpass -p $password ssh  root@$node "rm -rf /root/validation"
  sshpass -p $password ssh  root@$node "mkdir -p /root/validation"
  sshpass -p $password scp -o StrictHostKeyChecking=no ../validation.tar root@$node:/root/validation/.
  sshpass -p $password ssh  root@$node "ls"
  sshpass -p $password ssh  root@$node "cd /root/validation; tar -xvf ./validation.tar"
#  read
done

rm ../validation.tar
