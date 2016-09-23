#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.14
# Purpose: This script help execute remote shell.
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho  create
#
#
#

# Included scripts:
#
#   5-1.import_court_cert.sh  
#   Description :
#        This script help update ca trust for Root CA on all VMs.
         Without the certs, it can not establish connection with another application which use PCA cert.
#   Execute Host :
#       All VMs
##############################################################################

. $CONFIG_PATH/ose_config.sh

for HOST in `grep -v \# ${host_file_path}/${host_file} | awk '{ print $2 }'`
do
        ssh -q root@${HOST} "sh ${ose_temp_dir}/${after_install_path}/5-1.import_court_cert.sh  
done




 
