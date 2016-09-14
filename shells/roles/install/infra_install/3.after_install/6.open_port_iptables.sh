#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Open necessary ports (iptables)
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho   update comment
#
#
#
#
# Question : how to make it persistently
. ${CONFIG_PATH}/ose_config.sh

# Open port 1936 which is used by haproxy statistics
for HOST in `egrep "${node_prefix}" ${CONFIG_PATH}/${host_file} | awk '{ print $1 }' `
do
    ssh -q root@$HOST "iptables -A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 1936 -j ACCEPT"
    ssh -q root@$HOST "iptables -A OS_FIREWALL_ALLOW -p udp -m state --state NEW -m udp --dport 1936 -j ACCEPT"


# ADD this to /etc/sysconfig/iptables
   ssh -q root@$HOST "cp /etc/sysconfig/iptables /etc/sysconfig/iptables.`date +%F`"
   MYLINE=`grep -n COMMIT /etc/sysconfig/iptables | tail -1 | awk -F\: '{ print $1 }'`
   ssh -q root@$HOST "sed -i -e \"${MYLINE}i-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 1936 -j ACCEPT\" /etc/sysconfig/iptables"
   ssh -q root@$HOST "sed -i -e \"${MYLINE}i-A OS_FIREWALL_ALLOW -p udp -m state --state NEW -m udp --dport 1936 -j ACCEPT\" /etc/sysconfig/iptables"

echo " 'i-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 1936 -j ACCEPT' is added to /etc/sysconfig/iptables"
echo " 'i-A OS_FIREWALL_ALLOW -p udp -m state --state NEW -m udp --dport 1936 -j ACCEPT' is added to /etc/sysconfig/iptables"

done

