# Essecial package : nfs-util 
function validate_config(){
if [[ ! -e ${CONFIG_PATH}/${host_file} ]]; then
        if [[ $subdomain != $host_subdomain ]]; then
	     ${CONFIG_PATH}/generate_hosts_file.sh $host_subdomain $host_file $ose_version $env
        else 
	     ${CONFIG_PATH}/generate_hosts_file.sh $subdomain $host_file $ose_version $env
        fi
	echo "INFO: ${CONFIG_PATH}/${host_file} does not exist so ${CONFIG_PATH}/generate_hosts_file.sh is executed"
fi

if [[ -e ${CONFIG_PATH}/${host_file} ]]; then

	while read host 
	do
                if [[ z$host == z ]]; then
                        continue;
		elif [[ $(echo $host |awk -F" " '{print $2}' |grep ^#|wc -l) -eq  1 ]]; then
			continue;
		elif [[ $(echo $host| grep  '^..' |awk -F" " '{print $2}' |wc -l) -eq 0 ]]; then
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
export env="stg"
export ansible_hosts="ansible_hosts-${ose_version}.${env}"
export host_file="hosts.${env}"
export subdomain=$(grep subdomain ${ANSIBLE_PATH}/${ansible_hosts}|grep -v ^#|cut -d= -f2)
export host_subdomain="ctho.asbn.gtwy.dcn"
export inventory_dir_path="/home/oseadmin/jooho/ose_smart_start/ansible"
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

export password="os3@dm1n"
export node_prefix="nde007|nde008|nde009|nde010"
export master_prefix="mgt013|mgt014|mgt015"
export etcd_prefix="mgt016|mgt017|mgt018"
export infra_selector="region=infra,zone=${env}"
#export yum_repolist="rhel-7-server-extras-rpms rhel-7-server-ose-3.1-rpms rhel-7-server-rpms rhel-ha-for-rhel-7-server-rpms"
export yum_repolist="rhel-7-server-extras-rpms rhel-7-server-ose-3.1-rpms rhel-7-server-rpms"


export ansible_operation_vm="aoappd-w-dev001.ctho.sndg.gtwy.dcn"
export ose_cli_operation_vm="aoappd-e-mgt013.ctho.asbn.gtwy.dcn"
export etcd_is_installed_on_master="true"
export docker_log_max_file="3"
export docker_log_max_size="300m"
export docker_storage_dev="vda"
export docker_registry_route_url=registry.cloudapps.example.com
export docker_registry_svc_ip=172.30.0.2
export ose_temp_dir=/home/oseadmin/ose
#docker image version
export image_version=v3.1.1.6

. ${CONFIG_PATH}/nfs_config.sh
. ${CONFIG_PATH}/pv_config.sh

