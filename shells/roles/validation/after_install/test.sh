. $CONFIG_PATH/ose_config.sh

export prefix="mgt013|mgt014|mgt015"
for host in $all_hosts 
do
  if [[ $host =~ $prefix ]]
  then
     echo "$host"
  else 
     echo "fail : $host"
  fi
done
  
