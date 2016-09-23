#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.25
# Purpose: Copy ose_smart_start script to all VMs if script is updated


. $CONFIG_PATH/ose_config.sh

# Archieve scripts
cd $HOME_PATH/; cd ..
tar cvf ./ose_smart_start.tar ./ose_smart_start

for HOST in `grep -v \# ${host_file_path}/${host_file} | awk '{ print $1 }'`;
do

  scp ~/.bashrc  oseadmin@${HOST}:
  scp ~/.bash_profile  oseadmin@${HOST}:

  ssh -q oseadmin@${HOST} "mkdir -p ${ose_temp_dir}/ose_smart_start"
  scp ./ose_smart_start.tar oseadmin@${HOST}:${ose_temp_dir}/.
  ssh -t -q oseadmin@${HOST} "tar xvf ${ose_temp_dir}/ose_smart_start.tar -C  ${ose_temp_dir}"

  #export essential variable
  ssh -t -q oseadmin@${HOST} "echo \"export HOME_PATH=${ose_temp_dir}/ose_smart_start\" >> ~/.bashrc"
  ssh -t -q oseadmin@${HOST} "echo \"export ANSIBLE_PATH=${ose_temp_dir}/ose_smart_start/ansible \" >> ~/.bashrc"
  ssh -t -q oseadmin@${HOST} "echo \"export CONFIG_PATH=${ose_temp_dir}/ose_smart_start/shells/config \" >> ~/.bashrc"
done
