#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.25
<<<<<<< HEAD
# Purpose: Check whether VMs are ready to install OpenShift Container Platform
#          Validate DNS / Validate yum repolist / Validate docker storage / Validate persistent volume
#
# History:
#          Date      |   Changes
#========================================================================
#        20160711        update comment
#
#
#
=======
# Purpose: Check whether VMs are ready to install
#          Validate DNS / Validate yum repolist / Validate docker storage / Validate persistent volume

>>>>>>> 43988bd5590e1d39e87ad520628990f0ede52ae3

# Included scripts:
#
#  - validation_dns_lookup.sh
#   Description :
#       In order to install openshift, all VMs hostname/lb should be resovled by DNS (wildcard${subdomain} is optional)
#       This script check DNS entries.       
#   Execute Host: 
#        All VMs

#  - validation_yum_repolist.sh
#   Description :
#       In order to install openshift, rhel7, rhel7 extra, ose3 repositories should be attached to all VMs.
#       This script check YUM repositories.       
#   Execute Host: 
#        All VMs

#  - validation_docker_storage.sh
#   Description :
#       Using docker storage is strongly recommended so this script check it is already configured or not. However it is not mandatory.
#   Execute Host: 
#        All VMs

#  - validation_persistent_vol.sh
#   Description :
#       This script check NFS server connectivity and GUID for using PV
#   Execute Host: 
#        All VMs

. $CONFIG_PATH/ose_config.sh

<<<<<<< HEAD
cd $HOME_PATH/; cd ..
tar cvf ./ose_smart_start.tar ./ose_smart_start
exit 0
=======
#cd $HOME_PATH/; cd ..
#tar cvf ./ose_smart_start.tar ./ose_smart_start
>>>>>>> 43988bd5590e1d39e87ad520628990f0ede52ae3
#for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $1 }'`;
do

  scp ~/.bashrc  oseadmin@${HOST}:
  scp ~/.bash_profile  oseadmin@${HOST}:

# Create temp directory and copy scripts
  ssh -q oseadmin@${HOST} "mkdir -p ${ose_temp_dir}/ose_smart_start"
  scp ./ose_smart_start.tar oseadmin@${HOST}:${ose_temp_dir}/.
  ssh -t -q oseadmin@${HOST} "tar xvf ${ose_temp_dir}/ose_smart_start.tar -C  ${ose_temp_dir}"

# import essential variables to ~/.bashrc
  ssh -t -q oseadmin@${HOST} "echo \"export HOME_PATH=${ose_temp_dir}/ose_smart_start\" >> ~/.bashrc"
  ssh -t -q oseadmin@${HOST} "echo \"export ANSIBLE_PATH=${ose_temp_dir}/ose_smart_start/ansible \" >> ~/.bashrc"
  ssh -t -q oseadmin@${HOST} "echo \"export CONFIG_PATH=${ose_temp_dir}/ose_smart_start/shells/config \" >> ~/.bashrc"
  ssh -t -q oseadmin@${HOST} "sudo yum install bind-utils -y"
  
  echo "============================================================================"
  echo "=================== Validate oseadmin@${HOST} ==================="
  echo "============================================================================"

  echo ""
  echo "***** validation_dns_lookup on oseadmin@${HOST} ******"
  echo ""
  ssh -q oseadmin@${HOST} "sh  ${ose_temp_dir}/ose_smart_start/shells/roles/validation/pure_vm_check/validation_dns_lookup.sh"
  read
  
  echo ""
  echo "***** validation_yum_repolist on oseadmin@${HOST} ******"
  echo "        NOTE : This validation could be fail.    "
  echo ""
  ssh -q oseadmin@${HOST} "sh ${ose_temp_dir}/ose_smart_start/shells/roles/validation/pure_vm_check/validation_yum_repolist.sh" 
  read 
  
  echo ""
  echo "***** validation_docker_storage on oseadmin@${HOST} ******"
  echo "        NOTE : This validation could be fail.    "
  echo ""
  ssh -q oseadmin@${HOST} "sh ${ose_temp_dir}/ose_smart_start/shells/roles/validation/pure_vm_check/validation_docker_storage.sh" 
  read 

  echo ""
  echo "***** validation_persistent_vol on oseadmin@${HOST} ******"
  echo "        NOTE : This validation could be fail.    "
  echo ""
  ssh -q oseadmin@${HOST} "sh ${ose_temp_dir}/ose_smart_start/shells/roles/validation/pure_vm_check/validation_persistent_vol.sh "
  read 
done
