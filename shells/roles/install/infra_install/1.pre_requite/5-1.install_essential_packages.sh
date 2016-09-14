#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: This script install several packages which help debug issues or increate productivity
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho   create
#
#
#

. $CONFIG_PATH/ose_config.sh


#Install the following base packages:
yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion nfs-utils nmap -y

#Update the system to the latest packages:
yum update -y


