#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.02
# Purpose: iptables allow 3128 port which use squid on Masters/Infra nodes
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  update comment
#
#
#

. $CONFIG_PATH/ose_config.sh

# ADD this to the running iptables configuration
iptables -I OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 3128 -j ACCEPT

# ADD this to /etc/sysconfig/iptables
cp /etc/sysconfig/iptables /etc/sysconfig/iptables.`date +%F`

MYLINE=`grep -n COMMIT /etc/sysconfig/iptables | tail -1 | awk -F\: '{ print $1 }'`
sed -i -e "${MYLINE}i-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 3128 -j ACCEPT" /etc/sysconfig/iptables

echo " 'i-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 3128 -j ACCEPT' is added to /etc/sysconfig/iptables"
exit 0
