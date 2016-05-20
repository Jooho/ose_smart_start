# Essecial package : nfs-util 
function validate_config(){
if [[ ! -e ${CONFIG_PATH}/${host_file} ]]; then
	${CONFIG_PATH}/generate_hosts_file.sh $subdomain $host_file 
	echo "INFO: ${CONFIG_PATH}/${host_file} does not exist so ${CONFIG_PATH}/generate_hosts_file.sh is executed"
fi

if [[ -e ${CONFIG_PATH}/${host_file} ]]; then

	while read host 
	do
		if [[ $(echo $host |grep ^#|wc -l) -eq 1 ]]; then
			continue;
		elif [[ $(echo $host|awk -F" " '{print $2}' | grep -v ^$|wc -l) -eq 0 ]]; then
			echo "Error: You should add ip for ${host} in $CONFIG_PATH/${host_file}"
			exit 9
		fi
	done < ${CONFIG_PATH}/${host_file}

fi

if [[ ! -e ${ANSIBLE_PATH}/ansible_hosts-${ose_version}.${env} ]]; then
	echo "${ANSIBLE_PATH}/ansible_hosts-${ose_version}.${env} does not exist. Process stopped"
	exit 2
else
	echo "============================="
	echo "Pass configuration validation"
	echo "============================="
	echo ""
fi
};

export ose_version="3.1"
export env="smart"
export ansible_hosts="ansible_hosts-${ose_version}.${env}"
export host_file="hosts.${env}"
export subdomain=$(grep subdomain ${ANSIBLE_PATH}/${ansible_hosts}|grep -v ^#|cut -d= -f2)
if [[ z${env} != z ]]; then
	subdomain=${env}.${subdomain}
fi
export openshift_master_cluster_public_hostname=$(grep openshift_master_cluster_public_hostname ${ANSIBLE_PATH}/${ansible_hosts}|grep -v ^#|cut -d= -f2)
export openshift_master_cluster_hostname=$(grep openshift_master_cluster_hostname ${ANSIBLE_PATH}/${ansible_hosts}|grep -v ^#|cut -d= -f2)
export all_hosts
export all_ip

validate_config

# Look for number of the first # character from hosts_${env}. After the #, it might have public cluster master url,
# cluster master url or subdomain url
line=$(cat ${CONFIG_PATH}/${host_file} |grep -n ^# |head -1|awk -F":" '{print $1}')

if [[ z$line == z ]];then
	all_hosts=$(cat ${CONFIG_PATH}/${host_file} | awk '{ print $1 }' | tr '\n' ' ')
	all_ip=$(cat ${CONFIG_PATH}/${host_file} | awk '{ print $2 }' | tr '\n' ' ')
else
	all_hosts=$(cat ${CONFIG_PATH}/${host_file} | awk '{ print $1 }' |sed "${line},100d" | tr '\n' ' ')
	all_ip=$(cat ${CONFIG_PATH}/${host_file} | awk '{ print $2 }' | sed "${line},100d" | tr '\n' ' ')
fi

# registry.${env}.${subdomain}

#Debug log
#echo $line
#echo $all_hosts
#echo $all_ip
#echo "# number"

export password="redhat"
export node_prefix="node"
export master_prefix="master"
export etcd_prefix="etcd"
export infra_selector="region=infra"
export yum_repolist="rhel-7-server-extras-rpms rhel-7-server-ose-3.1-rpms rhel-7-server-rpms rhel-ha-for-rhel-7-server-rpms"




export ansible_operation_vm="master1.example.com"
export etcd_is_installed_on_master="true"
export docker_log_max_file="3"
export docker_log_max_size="300m"
export docker_storage_dev="vda"
export docker_registry_route_url=registry.cloudapps.example.com

#docker image version
export image_version=v3.1.1.6

. ${CONFIG_PATH}/nfs_config.sh
. ${CONFIG_PATH}/pv_config.sh

