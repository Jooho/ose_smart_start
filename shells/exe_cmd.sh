. ./ose_config.sh
password=redhat
echo $all_ip
for node in $all_hosts
do
  echo " "
  echo "Test DNS on $node"
  echo " "
  sshpass -p $password ssh root@$node "$1"

done

