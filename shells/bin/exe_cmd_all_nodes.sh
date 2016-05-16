. ../config/ose_config.sh

password=redhat
echo $all_ip
for node in $all_hosts
do
  echo " "
  echo "Test DNS on $node"
  echo " "
  if [[ z$1 == z ]]; then
     sshpass -p $password ssh root@$node "$1"
  else
     if [[ $node =~ $2 ]]; then
       sshpass -p $password ssh root@$node "$1"
     fi
  fi
done

