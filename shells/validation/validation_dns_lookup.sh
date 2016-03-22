. ../ose_config.sh 

echo $etcd_is_installed_on_master
echo $all_hosts
for host in $all_hosts
do
echo $host
#echo  "nslookup $host"
#	nslookup $host
#    dig $host
#    echo dig $host
#
done
