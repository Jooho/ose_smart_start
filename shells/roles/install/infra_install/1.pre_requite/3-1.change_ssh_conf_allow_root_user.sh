#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: Change sshd_config to allow root user can be accessible directly.
#          After installation(before security scanning), this configuration must roll back.
#
# History:
#          Date      |   Changes
#========================================================================
#        20160711        update comment
#
#
#



if [ `id -u` != 0 ]; then echo "ERROR: You need to be root.  Exiting"; exit 9; fi

# Allow sudo NOPASSWD for wheel (reverse this after the installation is complete
sed -i -e 's/^%wheel/##%wheel/g' /etc/sudoers
sed -i -e 's/^# %wheel/%wheel/g' /etc/sudoers

if [ ! -f ~/.ssh/id_rsa.pub ]; 
then 
	echo | ssh-keygen -b2048 -trsa -N ''
fi

# oseadmin auth_keys should be sufficient to allow the install node to connect
cp /etc/ssh/sshd_config /etc/ssh/sshd_config-ori-`date +%F%H%M`
#cp ~oseadmin/.ssh/authorized_keys /root/.ssh/authorized_keys
sed -i -e 's/^PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i -e 's/\#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
systemctl restart sshd
exit 0
