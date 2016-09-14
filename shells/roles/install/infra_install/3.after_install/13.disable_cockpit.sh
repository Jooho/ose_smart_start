#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.16
# Purpose: Disable cockpit
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   updated comments
#
#
#

. ${CONFIG_PATH}/ose_config.sh

for HOST in `egrep "${master_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do

 ssh root@$HOST bash -c '"
 systemctl disable cockpit.service
 systemctl stop cockpit.service
 systemctl disable cockpit.socket
 systemctl stop cockpit.socket
"'

done

