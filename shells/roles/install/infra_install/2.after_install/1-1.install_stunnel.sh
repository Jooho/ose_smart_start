#!/bin/bash
#
# @(#)$Id$
#
# Purpose:  Explain how to implement Secure LDAP using a non-TLS tunnel
#  Author:  jradtke@redhat.com
#    Date:
#   Notes:  OSE will not accept a non-perfect TLS connection.  Jenie does not
#             use a valid cert (it is self-signed).  Therefore, we implemented
#             this work-around - which is still secure, but subject to some
#             particular attack vectors - MiM, for example.

# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho   update stunnel.service configuration and confirmed this script works.
#
#
#

## STUNNEL HOWTO
# http://www.tldp.org/HOWTO/archived/LDAP-Implementation-HOWTO/ssl.html
# https://www.stunnel.org/howto.html
mkdir -p /usr/local/ssl/certs
openssl s_client -connect hpgst328.jenie.ao.dcn:636 < /dev/null | awk '/Server certificate/{flag=1;next}/^subject/{flag=0}flag' >  /usr/local/ssl/certs/hpgst328.jenie.ao.dcn.crt
chmod 0600 /usr/local/ssl/certs/hpgst328.jenie.ao.dcn.crt
#stunnel -c -d 389 -r hpgst328.jenie.ao.dcn:636

yum -y install stunnel

## Create stunnel.service

cat << EOF > /etc/systemd/system/stunnel.service
[Unit]
Description=SSL tunnel for network daemons
Documentation=man:stunnel https://www.stunnel.org/docs.html
DefaultDependencies=no
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target
Alias=stunnel.target

[Service]
Type=forking
EnvironmentFile=-/etc/stunnel/stunnel.conf 
ExecStartPre=/usr/bin/mkdir -p /var/run/stunnel/var/run/
ExecStartPre=/usr/bin/chown -R nobody:nobody /var/run/stunnel/
ExecStart=/usr/bin/stunnel /etc/stunnel/stunnel.conf
#ExecStop=/usr/bin/killall -9 stunnel
RemainAfterExit=yes

# Give up if ping don't get an answer
#TimeoutSec=600

#Restart=always
#PrivateTmp=false
EOF

chmod 0644 /etc/systemd/system/stunnel.service
systemctl daemon-reload
systemctl status stunnel

# SETUP STUNNEL
cat << EOF >  /etc/stunnel/stunnel.conf
chroot = /var/run/stunnel/
setuid = nobody
setgid = nobody
pid = /var/run/stunnel.pid

[ldaps]
client = yes
accept = 127.0.0.1:389
connect = hpgst328.jenie.ao.dcn:636
EOF

## STARTING STUNNEL
# old way : /bin/stunnel /etc/stunnel/stunnel.conf -d 389 -r hpgst328.jenie.ao.dcn:636
systemctl enable stunnel.service
systemctl start stunnel.service
systemctl status stunnel.service

ps -ef | grep stun



############################################ It is not related with installation/configuration of stunnel ###################################
#[root@aoappd-e-mgt004 master]# nmap 127.0.0.1 -p 389
#
#Starting Nmap 6.40 ( http://nmap.org ) at 2016-03-23 14:17 EDT
#Nmap scan report for localhost (127.0.0.1)
#Host is up (-1700s latency).
#PORT    STATE SERVICE
#389/tcp open  ldap
#
#Nmap done: 1 IP address (1 host up) scanned in 0.04 seconds

# update your master-config.yaml
#  bindDN: uid=OpenShiftAdmin,ou=TSO,ou=applications,O=USCOURTS,C=US
#      bindPassword: "aqNWDDKk"
#      insecure: true
#      ca: ""
#      url: "ldap://127.0.0.1/o=USCOURTS,c=US?uid"
#
#
#######################################################################################################################
#openssl x509 -hash -in /usr/local/ssl/certs/hpgst328.jenie.ao.dcn.crt -noout
#
#### TESTING
## from /etc/hosts
## Testing something
#156.119.71.177 hpgst328.jenie.ao.dcn iams
#
## from master-config.yaml
#      insecure: false
#      ca: "/etc/origin/master/hpgst328.jenie.ao.dcn.crt"
#      #url: "ldap://hpgst022.jenie.ao.dcn/o=USCOURTS,c=US?uid"
#      #url: "ldaps://hpgst328.jenie.ao.dcn/o=USCOURTS,c=US?uid"
#      #url: "ldaps://IAMS/o=USCOURTS,c=US?uid"
#
#openssl s_client -connect hpgst328.jenie.ao.dcn:636 < /dev/null | awk '/Server certificate/{flag=1;next}/^subject/{flag=0}flag' >  /etc/origin/master/hpgst328.jenie.ao.dcn.crt
#
#systemctl restart atomic-openshift-master-api
#Mar 23 13:36:17 aoappd-e-mgt004.ctho.asbn.gtwy.dcn atomic-openshift-master-api[107018]: E0323 13:36:17.430741  107018 empties.go:28] AuthenticationError: LDAP Result Code 200 "": x509: certificate signed by unknown authority (possibly because of "x509: invalid signature: parent certificate cannot sign this kind of certificate" while trying to verify candidate authority certificate "IAMS")
#
## from master-config.yaml
#      insecure: true
#      ca: ""
#      #url: "ldap://hpgst022.jenie.ao.dcn/o=USCOURTS,c=US?uid"
#      url: "ldaps://hpgst328.jenie.ao.dcn/o=USCOURTS,c=US?uid"
#      #url: "ldaps://IAMS/o=USCOURTS,c=US?uid"
#
#Mar 23 13:39:05 aoappd-e-mgt004.ctho.asbn.gtwy.dcn atomic-openshift-master-api[107227]: oauthConfig.identityProvider[0].provider.url: invalid value 'ldaps://hpgst328.jenie.ao.dcn/o=USCOURTS,c=US?uid', Details: Cannot use ldaps scheme with insecure=true
#
## from master-config.yaml
#      insecure: false
#      ca: ""
#      #url: "ldap://hpgst022.jenie.ao.dcn/o=USCOURTS,c=US?uid"
#      url: "ldap://hpgst328.jenie.ao.dcn/o=USCOURTS,c=US?uid"
#      #url: "ldaps://IAMS/o=USCOURTS,c=US?uid"
#
#Mar 23 13:40:18 aoappd-e-mgt004.ctho.asbn.gtwy.dcn atomic-openshift-master-api[107309]: E0323 13:40:18.574688  107309 empties.go:28] AuthenticationError: LDAP Result Code 200 "": dial tcp 156.119.71.177:389: connection refused
####
