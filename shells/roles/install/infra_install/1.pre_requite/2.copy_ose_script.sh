#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.25
# Purpose: Copy ose_smart_start script to all VMs if script is updated
#          If some scrips are modified after copyed script, you can synchronize script using "git pull"
#          ${HOME_PATH}/shells/bin/exe_cmd_all_nodes.sh "cd ${ose_temp_dir}/ose_smart_start; git pull" 
#          Note: it must be accessible to gitlab from each VM
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  update comment
#
#
#


. $CONFIG_PATH/ose_config.sh

# Archieve scripts
cd $HOME_PATH/; cd ..
tar cvf ./ose_smart_start.tar ./ose_smart_start

for HOST in `grep -v \# $CONFIG_PATH/$host_file | awk '{ print $1 }'`;
do
  scp ~/.bashrc  ${con_user}@${HOST}:
  scp ~/.bash_profile  ${con_user}@${HOST}:

  ssh -q ${con_user}@${HOST} "mkdir -p ${ose_temp_dir}/ose_smart_start"
  scp ./ose_smart_start.tar  ${con_user}@${HOST}:${ose_temp_dir}/.
  ssh -t -q ${con_user}@${HOST} "tar xvf ${ose_temp_dir}/ose_smart_start.tar -C  ${ose_temp_dir}"

  #export essential variable
  ssh -t -q ${con_user}@${HOST} "echo \"export HOME_PATH=${ose_temp_dir}/ose_smart_start\" >> ~/.bashrc"
  ssh -t -q ${con_user}@${HOST} "echo \"export ANSIBLE_PATH=${ose_temp_dir}/ose_smart_start/ansible \" >> ~/.bashrc"
  ssh -t -q ${con_user}@${HOST} "echo \"export CONFIG_PATH=${ose_temp_dir}/ose_smart_start/shells/config \" >> ~/.bashrc"
done
