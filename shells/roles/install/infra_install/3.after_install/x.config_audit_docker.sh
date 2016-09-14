#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.16
# Purpose: Configure auditd for docker and enable it

. ${CONFIG_PATH}/ose_config.sh

for HOST in `cat  $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do
  ssh root@$HOST bash -c '"
cat << EOF > /etc/audit/rules.d/docker.rules
-w /usr/bin/docker -k docker
-w /var/lib/docker -k docker
-w /etc/docker -k docker
-w /usr/lib/systemd/system/docker-registry.service -k docker
-w /usr/lib/systemd/system/docker.service -k docker
-w /var/run/docker.sock -k docker
-w /etc/sysconfig/docker -k docker
-w /etc/sysconfig/docker-network -k docker
-w /etc/sysconfig/docker-registry -k docker
-w /etc/sysconfig/docker-storage -k docker
-w /etc/default/docker -k docker
EOF
service auditd restart
auditctl -l
"'


done

