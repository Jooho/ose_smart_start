#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Redirect logs which contains specific word "openshift" and "docker" to file.
# Config file: ose_config.sh



## Update logging
# NOTE - you have to escape out the $ if you use the cat EOF method
cat << EOF > /etc/rsyslog.d/openshift.conf
\$template SyslFormat,"%timegenerated% %HOSTNAME% [OSE] %syslogtag%%msg:::space\$
if \$programname contains 'openshift' then /var/log/openshift.log"
EOF

cat << EOF > /etc/rsyslog.d/docker.conf
\$template SyslFormat,"%timegenerated% %HOSTNAME% [OSE] %syslogtag%%msg:::space\$
if \$programname contains 'docker' then /var/log/docker.log"
EOF

cat << EOF > /etc/logrotate.d/openshift.log
/var/log/openshift.log {
    missingok
    notifempty
    size 102400k
    daily
    create 0600 root root
}
EOF
cat << EOF > /etc/logrotate.d/docker.log
/var/log/docker.log {
    missingok
    notifempty
    size 102400k
    daily
    create 0600 root root
}
EOF

cat << EOF > /etc/logrotate.d/daemon.log
/var/log/daemon.log {
    missingok
    notifempty
    size 102400k
    daily
    create 0600 root root
}
EOF
cat << EOF > /etc/logrotate.d/kern.log
/var/log/kern.log {
    missingok
    notifempty
    size 102400k
    daily
    create 0600 root root
}
EOF

systemctl restart rsyslog

