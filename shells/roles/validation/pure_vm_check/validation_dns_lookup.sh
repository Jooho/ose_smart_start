#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.20
# Purpose: Check if essencial hostnames can be resolved by DNS
#          Hostnames :-
#               - all host domain names (ex, master1.example.com)
#               - router (ex, *.${env}.${subdomain})
#               - openshift_master_cluster_public_hostname (ex, api.${env}.${subdomain} ) 
#               - openshift_master_cluster_hostname (ex, aoappd-cluster.${env}.${subdomain}) 
# History:
#          Date      |   Changes
#========================================================================
#        20160711        update comment
#
#
#


. ${CONFIG_PATH}/ose_config.sh 

export success
export fail
export all_hosts_count=0

if [[ $debug == "true" ]];then
  echo "#### DEBUG ####"
  echo "ALL HOST : $all_hosts"
  echo "ALL IP : $all_ip"
  echo "###############"
  echo ""
fi

#Check all host domain names(masters/etcd/nodes)
for host in $all_hosts
do
  all_hosts_count=$((all_hosts_count + 1))
  for ip in $all_ip 
  do
    temp_result=$(dig $host|grep $ip)
    if [[ $? == 0 ]]; then
     echo "$host is resolved to $ip"
     success=("${success[@]}" "${host}")
    elif [[ $(echo ${fail[@]} |grep $host |wc -l) -eq 0 ]] ;
    then 
         fail=("${fail[@]}" "${host}")
    fi

    if [[ $(echo ${fail[@]} |grep $host |wc -l) -gt 0 ]] && [[ $(echo ${success[@]} |grep $host |wc -l) -gt 0 ]];
    then 
       count=${#fail[@]}
       unset fail[$((count-1))]
    fi

  done
done

# Check router domain

if [[ $debug == "true" ]];then
   echo "#### DEBUG ####"
   echo "SUBDOMAIN : $subdomain"
   echo "PUBLIC_CLUSTER_NAME : $openshift_master_cluster_public_hostname"
   echo "CLUSTER_NAME : $openshift_master_cluster_hostname"
   echo "###############"
   echo ""
fi

router_result=$(dig a.${subdomain}|grep -A2 "ANSWER SECTION")
if [[ $? == 0 ]]; then
 success=("${success[@]}" "*.${subdomain}")
else
 fail=("${fail[@]}" "*.${subdomain}")
fi

# Check public_cluster_master_hostname
if [[ $(echo $all_hosts |grep $openshift_master_cluster_public_hostname |wc -l) -eq 0 ]];then 
  public_cm_host_result=$(dig $openshift_master_cluster_public_hostname |grep -A2 "ANSWER SECTION") 
  if [[ $? == 0 ]]; then
    success=("${success[@]}" "${openshift_master_cluster_public_hostname}")
  else
    fail=("${fail[@]}" "$openshift_master_cluster_public_hostname")
  fi
else
   public_cm_host_result="This domain is already tested" #duplicated url
fi

# Check master_cluster_hostname
if [[ $(echo $all_hosts |grep $openshift_master_cluster_hostname |wc -l) -eq 0 ]];
then 
  cm_result=$(dig $openshift_master_cluster_hostname |grep -A2 "ANSWER SECTION") 
  if [[ $? == 0 ]]; then
   success=("${success[@]}" "${openshift_master_cluster_hostname}")
  else
   fail=("${fail[@]}" "$openshift_master_cluster_hostname")
  fi
else
   cm_host_result="This domain is already tested" #duplicated url
fi
echo ""
echo "------------------------------ "
echo "Success hostname : ${success[@]}"
#echo ${#fail[@]}
if [[ ${#fail[@]} == '0' ]] ;then
    echo ""
    echo "** Result >> PASS !!"
    echo ""
    echo " You have you check the real ip(router/public cluster master/cluster master) which is resolved by DSN manually"
    echo "================================================================="
    echo "router: $router_result"
    echo "================================================================="
    echo "public cluster master host: $public_cm_host_result"
    echo "================================================================="
    echo "cluster master host: $cm_host_result"
else
    echo "** Result >> FAIL ;("
    echo "${fail[@]}"
fi
