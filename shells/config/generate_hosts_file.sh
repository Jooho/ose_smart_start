#!/bin/bash
#
# @(#)$Id$
#
# Purpose: Create hosts file 
#  Author: Jooho Lee
#    Date: 2016.5.18
#   Notes: 



if [[ $# -eq 0 ]]; then 
	echo "this script should be executed by ose_config.sh" 
	exit 9
fi
export subdomain=$1
export host_file=$2
export ose_version=$3
export env=$4
subhostname=$( echo $subdomain | awk  -F'.' '{print $2 "." $3}' )  # example.com
#Debug log
#echo $subhostname
#echo $host_file
#echo $ose_version
#echo $env
all_hostnames=$(grep ${subhostname} $ANSIBLE_PATH/ansible_hosts-${ose_version}.${env} |grep -v ^# |sort | uniq)
touch "./${host_file}_unsorted"
touch "./${host_file}_extra_hostname"
touch "./${host_file}"

function split_hostname(){
	prefix=$(echo $1 | cut -d'[' -f1)
	postfix=$(echo $1 | cut -d']' -f2)
	first_range=$(echo $1 | cut -d'[' -f2|cut -d':' -f1)
	last_range=$(echo $1 | cut -d']' -f1|cut -d':' -f2)
	export splited_hostname
	for i in $(seq ${first_range} ${last_range}); 
	do
		echo "${prefix}${i}${postfix}" >> "./${host_file}_unsorted"
	done
}

for hosts in $all_hostnames; 
do
	for each_hostname in $hosts
	do
		if [[ $each_hostname =~ $subhostname ]]; then
			if [[ $each_hostname =~ "[" ]]; then
				hostnames=$(split_hostname "$each_hostname")     
				#split_hostname "master[1:2].example.com"
			elif [[ $each_hostname =~ "=" ]]; then   # this find public cluster master url/cluster master url 
				if [[ $(cat "./${host_file}_unsorted" |grep `echo $each_hostname |cut -d= -f2` |wc -l) -eq 0 ]]; then
					echo "#${each_hostname}"|cut -d'=' -f1 >> "./${host_file}_extra_hostname"
					echo $each_hostname |cut -d= -f2 >> "./${host_file}_extra_hostname"
				fi
			else
				echo $each_hostname >> "./${host_file}_unsorted"
			fi
		fi
	done
done

# Summarize temp files to $host_file
cat "./${host_file}_unsorted"|sort|uniq >> ./$host_file
cat "./${host_file}_extra_hostname" >> ./$host_file
#Clean temp files
rm "./${host_file}_unsorted"
rm "./${host_file}_extra_hostname" 
