#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.18
# Purpose: Configuration files
#          This script manage most varialbes which are used in all scripts.
#          Before executing this script, ansible hosts file must be in a ose_smart_start/ansible folder. This script
#          will extract some variable from the ansible script.
#
# History:
#          Date      |   Changes
#========================================================================
#        20160711        update comment/satellite variables
#        20160714        squid_svc_ip added
#        20160721        add images_config.sh
#        20160801        Backup sbx
#        20160802        Backup rhev
#



# Essecial package : nfs-util,bind-utils


#This function check if the hosts.${env} file exist.
#      If not, generate_hosts_files.sh will be executed. The hosts.${env} file contains vm domain name.
#      If exist, it also check the ip is added or not.


### Usage
# fun=$(get_specific_hosts_ips master ip| tr -s " " "," )
# echo "test $fun"
# Result
# test 10.162.19.240,10.162.19.241,10.162.19.242

get_specific_hosts_ips(){

export prefix
export need_host_ip

case "$1" in
        master)
                prefix="master_prefix"
                ;;
        node)
                prefix="node_prefix"
                ;;
        etcd)
                prefix="etcd_prefix"
                ;;
        infra)
                prefix="infra_prefix"
                ;;
        *)
                echo "Usage: get_specific_hosts_ips() [master|node|etcd|infra] [ip|host]"
        exit 1
     esac
#echo $prefix
case "$2" in
        ip)
                need_host_ip="ip"
                ;;
        host)
                need_host_ip="host"
                ;;
        *)
                echo "Usage: get_specific_hosts_ips() [master|node|etcd] [ip|host]"
        exit 1

   esac
#echo $need_host_ip
nested_prefix_value=$prefix
export detected_ip
export detected_host
while read host
do
#   echo "prefix : ${!nested_prefix_value}"
     if [[ $host =~ ${!nested_prefix_value} ]]; then
        if [[ $need_host_ip == "host" ]]; then
           hostname=$(echo $host | awk '{print $1}')
          # echo $hostname
           detected_host=("${detected_host[@]}" "${hostname}")
        else
           ip=$(echo $host | awk '{print $2}')
           detected_ip=("${detected_ip[@]}" "${ip}")
        fi
     fi
done < ${CONFIG_PATH}/${host_file}

if [[ $need_host_ip == "host" ]]; then
    echo $(echo ${detected_host[@]})
else
    echo $(echo ${detected_ip[@]})
fi
}

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
# debug="true" : Print debug log
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
# docker_registry_nfs_mount_point=ose-registry : If you will use nfs direct mount to docker registry, you should specify it
#                                               inside 'docker_registry_attach_nfs.sh' file, it will be used like "${NFS_MOUNT_POINT}/${docker_registry_nfs_mount_point}
# docker_registry_svc_ip : Service ip for docker registry (it will help keep the svc ip even though docker registry is redeployed
# ose_temp_dir : the temp directory which will contain ose_smart_start scripts
#docker image version
# image_version=v3.1.1.6


# Automatic configured variables
# all_hosts : domain names which are used in ansible hosts (Masters/ETCD/Nodes)
# all_ip : IP address which are used in ansible hosts (Masters/ETCD/Nodes)



. ${CONFIG_PATH}/ose_config.sh.sbx
. ${CONFIG_PATH}/nfs_config.sh
. ${CONFIG_PATH}/pv_config.sh
. ${CONFIG_PATH}/images_config.sh.31

