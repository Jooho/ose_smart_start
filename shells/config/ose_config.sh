#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.18
# Purpose: Configuration files
#          This script manage most varialbes which are used in all scripts. 
#          Before executing this script, ansible hosts file must be in a ose_smart_start/ansible folder. This script
#          will extract some variable from the ansible script.

# Essecial package : nfs-util,bind-utils 


#This function check if the hosts.${env} file exist. 
#      If not, generate_hosts_files.sh will be executed. The hosts.${env} file contains vm domain name.
#      If exist, it also check the ip is added or not.

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

# Description
# ose_version="3.1" : Openshift major.minor version
# env="stg"   : Cluster information and this variable will be used for ansbile_hosts/host_file variable because it is normal pattern client try
# ansible_hosts : ansible host files
# host_file : hosts hostname/IP information"
# subdomain : Openshift subdomain information (It is usually used for VM host domain name)
#             If you specify env, the subdomain will contains ${env} like ${env}.${subdomain}
# host_subdomain : VM host subdomain name (If subdoamin is different from host name, this variable can be used)
# inventory_dir_path : The path for ansible hosts (You can use $ANSIBLE_PATH)

# yum_repolist : essential repositories to install Openshift 
# password : password for root (But if ssh does not allow to access with root user, this variable is useless)
# node_prefix : prefix which indicate nodes
# master_prefix : prefix which indicate master
# etcd_prefix : prefix which indicate etcd
# infra_selector : selector which deploy router and registry
# ansible_operation_vm : the node which will run ansible-playbook
# ose_cli_operation_vm : the node which will run oc command( normally the first master )
# etcd_is_installed_on_master : If etcd is installed on master node, set true
# docker_log_max_file : it set the max file of lograting docker log file 
# docker_log_max_size : it set the max size of docker log file.
# docker_storage_dev : block device for docker storage
# docker_registry_route_url : route for docker registry
# docker_registry_svc_ip : Service ip for docker registry (it will help keep the svc ip even though docker registry is redeployed
# ose_temp_dir : the temp directory which will contain ose_smart_start scripts
#docker image version
# image_version=v3.1.1.6


# Automatic configured variables
# all_hosts : domain names which are used in ansible hosts (Masters/ETCD/Nodes)
# all_ip : IP address which are used in ansible hosts (Masters/ETCD/Nodes)


export ose_version="3.1"     # Update
export env="stg"             # Update
export ansible_hosts="ansible_hosts-${ose_version}.${env}"
export host_file="hosts.${env}"
export subdomain=$(grep subdomain ${ANSIBLE_PATH}/${ansible_hosts}|grep -v ^#|cut -d= -f2)
export host_subdomain="ctho.asbn.gtwy.dcn"     # Update
export inventory_dir_path=$ANSIBLE_PATH
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

export password="os3@dm1n"                          # Update
export node_prefix="nde007|nde008|nde009|nde010"    # Update
export master_prefix="mgt013|mgt014|mgt015"         # Update
export etcd_prefix="mgt016|mgt017|mgt018"           # Update
export infra_selector="region=infra,zone=${env}"    # Update
#export yum_repolist="rhel-7-server-extras-rpms rhel-7-server-ose-3.1-rpms rhel-7-server-rpms rhel-ha-for-rhel-7-server-rpms"
export yum_repolist="rhel-7-server-extras-rpms rhel-7-server-ose-3.1-rpms rhel-7-server-rpms"


export ansible_operation_vm="aoappd-w-dev001.ctho.sndg.gtwy.dcn"    # Update
export ose_cli_operation_vm="aoappd-e-mgt013.ctho.asbn.gtwy.dcn"    # Update
export etcd_is_installed_on_master="true"                           # Update
export docker_log_max_file="3"    
export docker_log_max_size="300m"
export docker_storage_dev="vda"                                     # Update
export docker_registry_route_url=registry.cloudapps.example.com     # Update
export docker_registry_svc_ip=172.30.0.2                            # Update
export ose_temp_dir=/home/oseadmin/ose                              # Update
#docker image version
export image_version=v3.1.1.6                                       # Update

. ${CONFIG_PATH}/nfs_config.sh
. ${CONFIG_PATH}/pv_config.sh

