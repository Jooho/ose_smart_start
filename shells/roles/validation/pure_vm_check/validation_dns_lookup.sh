# Check if essencial hostnames can be resolved by DNS
# all host domain names
# router *.${env}.${subdomain}
# public_cluster_master_url (ex, api.${env}.${subdomain} ) 
# cluster_master_url (ex, aoappd-cluster.${env}.${subdomain}) 

. ../../../config/ose_config.sh 

export success=0
export all_hosts_count=0

#Check all host domain nanmes
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

# Check router domain
temp_result=$(dig ${subdomain}|grep $
echo "------------------------------ "
echo "Tested VM count :  $all_hosts_count "
echo "Success VM count : $success"
if [[ $all_hosts_count == $success ]];then
    echo "** Result >> PASS !!"
else
    echo "** Result >> FAIL ;("
fi
