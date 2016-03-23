. ../../ose_config.sh

#Check if the following base packages installed:
export base_packages="wget git net-tools bind-utils iptables-services bridge-utils bash-completion nfs-utils docker"
export installed_packages_count=0
export base_packages_count=0
export login_count=0
export all_hosts_count=0
export all_node_hosts_count=0
export docker_storage_count=0

#Get information about rpm_list
rpm -qa > ./rpm_list.out


#Master
if [[ $(hostname) == ${ansible_operation_vm} ]]
then
   
   base_packages="$base_packages atomic-openshift-utils"

   for host in $all_hosts 
   do
     all_hosts_count=$((all_hosts_count + 1))
     #echo "sshpass -p $password ssh root@\$host 'echo `hostname` can be logined from ${ansible_operation_vm}| wc -l'"
     ssh -q root@$host 'echo `hostname` can be logined from ' ${ansible_operation_vm}
     temp_login_result=$( ssh root@$host 'echo `hostname` can be logined from ${ansible_operation_vm}| wc -l')
     
     login_count=$((login_count + temp_login_result))
   done

# Node only has docker-storage
elif [[ $(hostname) =~ ${node_prefix} ]]
then
    #Check Docker storage is configured
    all_node_hosts_count=$((all_node_hosts_count + 1))
    temp_docker_storage_result=$(lvs | grep docker-pool | wc -l)
    #lvs | grep docker-pool  

     docker_storage_count=$((docker_storage_count + temp_docker_storage_result))
    #echo $docker_storage_count
fi
#ls /var/lib/docker/

#ps -ef|grep docker
docker_log_opt_config=$(grep log-opt /etc/sysconfig/docker|wc -l)
docker_log_opt_runtime=$(ps -ef|grep log-opt /etc/sysconfig/docker|grep -v grep|wc -l)
#grep log-opt /etc/sysconfig/docker
#ps -ef|grep log-opt|grep -v grep




echo "------------------------------ "
echo "Neccessary packages $base_packages installation:"
if [[ $base_packages_count == $installed_packages_count ]];then
   echo "** Result >> PASS !!"
else
   echo "** Result >> FAIL ;("
fi    

if [[ $(hostname) == ${ansible_operation_vm} ]]
then
   echo "" 
   echo "Access to all vms from ${ansible_operation_vm}:" 
   if [[ $all_hosts_count == $login_count ]];then
       echo "** Result >> PASS !!"
   else
      echo "** Result >> FAIL ;("
   fi
fi

#echo $(hostname) =~ ${node_prefix} 
if [[ $(hostname) =~ ${node_prefix} ]]
then
    echo "" 
    echo "Set up docker storage on node vm :"
    if [[ $docker_storage_count == $all_node_hosts_count ]];then
        echo "** Result >> PASS !!"
    else
        echo "** Result >> FAIL ;("
    fi
fi

echo "" 
echo "Config docker log-opt on vm :"
if [[ $docker_log_opt_config == 1 && $docker_log_opt_runtime == 1 ]];then
    echo "** Result >> PASS !!"
else
    echo "** Result >> FAIL ;("
fi
