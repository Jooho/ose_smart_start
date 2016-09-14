#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: This script install docker 1.8.2
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  update comment
#
#
#


. $CONFIG_PATH/ose_config.sh

# This should be moved to Validation part
export docker_version
for HOST in `cat $CONFIG_PATH/$host_file | awk '{ print $1 }' `
do
 if [[ $HOST =~ $master_prefix ]] ||  [[ $HOST =~ $node_prefix ]]; then
   if [[ $ose_version == "3.1" ]]; then
       docker_version="1.8.2"
   else
       docker_version="1.9.1"
   fi
       ssh -q root@$HOST "uname -n; yum list docker-${docker_version}"
 fi
done

# Cofigure Docker Nodes
cat << EOF > ./my-docker-storage-setup
if [ -b /dev/${docker_storage_dev} ]
then
  /usr/bin/docker-storage-setup
  systemctl stop docker
  rm -rf /var/lib/docker/*
  systemctl start docker
  systemctl enable docker
  systemctl status docker
fi
EOF

# Run the following everywhere but the ETCD nodes...
for HOST in $(cat $CONFIG_PATH/$host_file | awk '{ print $1 }')
do
if [[ $HOST =~ $master_prefix ]] ||  [[ $HOST =~ $node_prefix ]]; then
    echo "########## ############### ###############"
    echo "NOTE: working on $HOST"
    scp ./my-docker-storage-setup root@${HOST}:my-docker-storage-setup
    ssh root@${HOST} "yum -y install docker-${docker_version}"
    ssh root@${HOST} "sh ./my-docker-storage-setup"
    echo
fi
done

## Example remote command
#for HOST in `grep mgt $CONFIG_PATH/$host_file | awk '{ print $1 }'`
#do
#  ssh root@$HOST bash -c '"
#uptime
#"'
#done
