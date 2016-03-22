. ./ose_config.sh 
password=redhat
validation_path=/root/shell
echo $all_ip
tar -cvf ../validation.tar ./
for node in $all_hosts
do
  echo " "
  echo "Test DNS on $node"
  echo " "
  sshpass -p $password ssh  root@$node "rm -rf $validation_path"
  sshpass -p $password ssh  root@$node "mkdir -p $validation_path"
  sshpass -p $password scp -o StrictHostKeyChecking=no ../validation.tar root@$node:$validation_path/.
  sshpass -p $password ssh  root@$node "ls"
  sshpass -p $password ssh  root@$node "cd $validation_path; tar -xvf ./validation.tar"
#  read
done

rm ../validation.tar
