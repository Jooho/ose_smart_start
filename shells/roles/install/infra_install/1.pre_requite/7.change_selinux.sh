#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: This script update selinux variable to allow pod(container) use NFS
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  update comment
#
#
#

. $CONFIG_PATH/ose_config.sh

#SELinux (enable virt_use_nfs/virt_sandbox_use_nfs)
for HOST in `cat ${host_file_path}/${host_file} | awk '{ print $1 }'`
do 
        echo "update selinux on $HOST"
	ssh -q root@$HOST "setsebool -P virt_use_nfs=true; setsebool -P virt_sandbox_use_nfs 1"
done
