. ./ose_config.sh 
password=redhat
echo $all_ip
for node in $all_hosts
do
  echo " "
  echo "Pre-requites to  $node"
  echo " "
  sshpass -p $password ssh root@$node "cd /root/shell/install; ./pre_requites.sh "

  #read
done

