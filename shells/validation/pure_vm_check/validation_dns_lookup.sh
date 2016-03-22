. ../../ose_config.sh 

export success=0
export all_hosts_count=0
for host in $all_hosts
do
  all_hosts_count=$((all_hosts_count + 1))
  for ip in $all_ip 
  do
    temp_result=$(dig $host|grep $ip)
    if [[ $? == 0 ]]; then
     echo "$host is resolved to $ip"
     success=$((success + 1))
    fi
  done
done

echo "------------------------------ "
echo "Tested VM count :  $all_hosts_count "
echo "Success VM count : $success"
if [[ $all_hosts_count == $success ]];then
  echo "PASS !!"
else
  echo "FAIL ;("
fi
