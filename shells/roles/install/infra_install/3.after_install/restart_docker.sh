#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.24
# Purpose: Restart docker on all nodes


#Question : why id_rsa-aoappd need?
#for HOST in `oc get nodes | awk '{ print $1 }' | egrep -v 'NAME|mgt004'`;
for HOST in `oc get nodes | awk '{ print $1 }'`;
do
    #ssh -q -i /root/.ssh/id_rsa-aoappd-w-dev001 root@$HOST "systemctl restart docker"
    #ssh -q -i /root/.ssh/id_rsa-aoappd-w-dev001 root@$HOST "uname -n; systemctl is-active docker"
    ssh -q root@$HOST "systemctl restart docker"
    ssh -q root@$HOST "uname -n; systemctl is-active docker"
 done
