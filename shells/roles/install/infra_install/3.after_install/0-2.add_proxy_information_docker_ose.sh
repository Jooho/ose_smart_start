#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.02
# Purpose: Update Proxy information to atomic-openshift-master-api / atomic-openshift-master-controllers /  atomic-openshift-node / docker
#          
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   update comment
#
#
#

. $CONFIG_PATH/ose_config.sh

export etcd_ip_list
export etcd_host_list
export master_no_proxy
export master_ip_list=$(get_specific_hosts_ips master ip| tr -s " " "," )
export master_host_list=$(get_specific_hosts_ips master host| tr -s " " "," )

#echo  $master_ip_list
#echo  $master_host_list
#echo ""
#echo  $base_no_proxy

export base_no_proxy="localhost,127.0.0.1,172.30.0.1,${docker_registry_svc_ip},kubernetes.default.svc.cluster.local,${docker_registry_route_url},${openshift_master_cluster_hostname}"

# If etcd servce is not installed on master vm, you should specify etcd ip/hostname in no_proxy 
if [[ $etcd_is_installed_on_master != "true" ]]
then
  etcd_ip_list=$(get_specific_hosts_ips etcd ip| tr -s " " "," )
  etcd_host_list=$(get_specific_hosts_ips etcd host| tr -s " " "," )
  master_no_proxy="${base_no_proxy},${master_ip_list},${master_host_list},${etcd_host_list},${etcd_ip_list}"
else
  master_no_proxy="${base_no_proxy},${master_ip_list},${master_host_list}"
fi


# Update proxy configuration
update_proxy_info_compute(){
# On the Compute Nodes
cat << EOF >> /etc/sysconfig/atomic-openshift-node
HTTP_PROXY=${squid_svc_ip}:3128
HTTPS_PROXY==${squid_svc_ip}:3128
NO_PROXY=${master_no_proxy}
EOF

cat << EOF >> /etc/sysconfig/docker
# Proxy for outbound http requests
#HTTP_PROXY=http://10.160.200.30:8080/
HTTP_PROXY==${squid_svc_ip}:3128
HTTPS_PROXY==${squid_svc_ip}:3128
NO_PROXY=${base_no_proxy}
EOF
}

update_proxy_info_master(){
# On the masters
cat << EOF >> /etc/sysconfig/docker
# Proxy for outbound http requests
#HTTP_PROXY=http://10.160.200.30:8080/
#HTTPS_PROXY=http://10.160.200.30:8080/
HTTP_PROXY=localhost:3128
HTTPS_PROXY=localhost:3128
NO_PROXY=${base_no_proxy}
EOF

cat << EOF >> /etc/sysconfig/atomic-openshift-master-api
# Proxy for outbound http requests
#HTTP_PROXY=http://10.160.200.30:8080/
#HTTPS_PROXY=http://10.160.200.30:8080/
HTTP_PROXY=localhost:3128
HTTPS_PROXY=localhost:3128
NO_PROXY=${master_no_proxy}
EOF

cat << EOF >> /etc/sysconfig/atomic-openshift-master-controllers
# Proxy for outbound http requests
#HTTP_PROXY=http://10.160.200.30:8080/
#HTTPS_PROXY=http://10.160.200.30:8080/
HTTP_PROXY=localhost:3128
HTTPS_PROXY=localhost:3128
NO_PROXY=${master_no_proxy}
EOF
}

if [[ $HOSTNAME =~ $master_prefix ]]; then
    echo "NOTE: found $HOSTNAME"
    update_proxy_info_master
    echo "systemctl restart atomic-openshift-master-api"
    systemctl restart atomic-openshift-master-api 

    echo "systemctl restart atomic-openshift-master-controllers"
    systemctl restart atomic-openshift-master-controllers

    echo "systemctl restart docker"
    systemctl restart docker
fi

if [[ $HOSTNAME =~ $node_prefix ]]; then
    echo "NOTE: found $HOSTNAME"

    echo "systemctl restart atomic-openshift-node"
    systemctl restart atomic-openshift-node

    echo "systemctl restart docker"
    systemctl restart docker
   
    echo "update_proxy_info_compute"
    update_proxy_info_compute
fi
