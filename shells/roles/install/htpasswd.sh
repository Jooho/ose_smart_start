. $CONFIG_PATH/ose_config.sh

echo "Add user "joe" to OSE"
echo "---------------------"
echo ""
for host in $all_hosts
do
  if [[ $host =~ ${master_prefix} ]]; then
    sshpass -p $password ssh root@$host "htpasswd -b /etc/origin/master/htpasswd joe redhat"
    echo "joe user is added (pw:redhat)"
    echo ""
    sshpass -p $password ssh root@$host "systemctl restart atomic-openshift-master-api"
    echo "On $host, atomic-openshift-master-api restarted"
  fi
done
