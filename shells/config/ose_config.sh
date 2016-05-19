# Essecial package : nfs-util 
function validate_config(){
if [[ ! -e ${host_file} ]]; then
	./generate_hosts_file.sh $subdomain $host_file 
	echo "INFO: ${host_file} does not exist so ./generate_hosts_file.sh is executed"
fi

if [[ -e ${host_file} ]]; then

	while read host 
	do
		if [[ $(echo $host |grep ^#|wc -l) -eq 1 ]]; then
			continue;
		elif [[ $(echo $host|awk -F" " '{print $2}' | grep -v ^$|wc -l) -eq 0 ]]; then
			echo "Error: You should add ip for ${host} in ${host_file}"
			exit 9
		fi
	done < ./${host_file}

fi

if [[ ! -e ../../ansible/ansible_hosts-${ose_version}.${env} ]]; then
	echo "../../ansible/ansible_hosts-${ose_version}.${env} does not exist. Process stopped"
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
export subdomain=$(grep subdomain ../../ansible/${ansible_hosts}|grep -v ^#|cut -d= -f2)

validate_config

export all_hosts=$(cat ${host_file} | awk '{ print $1 }' | tr '\n' ' ')
export all_ip=$(cat ${host_file} | awk '{ print $2 }' | tr '\n' ' ')

# registry.${env}.${subdomain}

#Debug log
#echo $all_hosts
#echo $all_ip

export password="redhat"
export node_prefix="node"
export master_prefix="master"
export etcd_prefix="etcd"
export infra_selector="region=infra"
export yum_repolist="rhel-7-server-extras-rpms rhel-7-server-ose-3.1-rpms rhel-7-server-rpms rhel-ha-for-rhel-7-server-rpms"¬




export ansible_operation_vm="master1.example.com"
export etcd_is_installed_on_master="true"
export docker_log_max_file="3"
export docker_log_max_size="300m"
export docker_storage_dev="vda"
export docker_registry_route_url=registry.cloudapps.example.com

#docker image version
export image_version=v3.1.1.6

. ./nfs_config.sh
. ./pv_config.sh

