#!/bin/bash

tuned-adm profile virtual-guest 
# subscription-manager register --org 'MATRIX Labs' --activationkey '1-default-rhel7-prod' --baseurl https://rh7sat6.matrix.lab/pulp/repos

# subscription-manager register --auto-attach 
# subscription-manager repos --disable=*
# subscription-manager repos --enable rhel-7-server-rpms
#sh ./bootstrap.sh
ADMINPASSWD='Passw0rd'

# Config channel handles this now...
#cat << EOF >> /etc/hosts
## IDM HOSTS
#10.10.10.121	rh7idm01.matrix.lab rh7idm01
#10.10.10.122	rh7idm02.matrix.lab rh7idm02
#EOF

DEFAULTZONE=`firewall-cmd --get-default-zone`

PORTS="80/tcp 123/tcp 443/tcp 389/tcp 636/tcp 88/tcp 88/udp 464/tcp 464/udp 53/tcp 53/udp 123/udp 7389/tcp"
for PORT in $PORTS
do
  firewall-cmd --permanent --zone=${DEFAULTZONE} --add-port=${PORT}
done

SVCS=ntp
for SVC in $SVCS
do
  firewall-cmd --permanent --zone=${DEFAULTZONE} --add-service=${SVC}
done
firewall-cmd --reload
firewall-cmd --list-ports

sed -i -e 's/restrict ::1/restrict ::1\nrestrict 10.10.10.0 netmask 255.255.255.0 nomodify notrap/g' /etc/ntp.conf
systemctl enable chronyd && systemctl start chronyd 

yum -y install ipa-server bind bind-dyndb-ldap

case `hostname -s` in
  # MASTER - Run this first...
  rh7idm01)
# Use --no-ntp for IPA/IDM (Sec 2.4.6 from Install Guide)
IPA_OPTIONS="
--realm=MATRIX.lab
--domain=matrix.lab
--ds-password=Passw0rd
--master-password=Passw0rd
--admin-password=Passw0rd
--hostname=rh7idm01.matrix.lab
--ip-address=10.10.10.121
--setup-dns --no-forwarders
--no-ntp"
CERTIFICATE_OPTIONS="
--subject="
echo "NOTE:  You are likely going to see a warning/notice about entropy"
echo "  in another window, run:  rngd -r /dev/urandom -o /dev/random -f -t 1 &"
echo "ipa-server-install -U $IPA_OPTIONS $CERTIFICATE_OPTIONS"
ipa-server-install -U $IPA_OPTIONS $CERTIFICATE_OPTIONS
echo $ADMINPASSWD | kinit admin
klist

echo "You will likely want to add the entry to the RH7IDM01 DNS zone for RH7IDM02 before this next step"
ipa dnsrecord-add matrix.lab rh7idm02 --a-rec 10.10.10.122
ipa dnsrecord-add 10.10.10.in-addr.arpa 122 --ptr-rec rh7idm02.matrix.lab.
echo "  echo $ADMINPASSWD | ipa-replica-prepare rh7idm02.matrix.lab "
echo $ADMINPASSWD | ipa-replica-prepare rh7idm02.matrix.lab 

ssh-copy-id rh7idm02
scp -oStrictHostKeyChecking=no /var/lib/ipa/replica-info-rh7idm02.matrix.lab.gpg rh7idm02:.
#cp /tmp/sample.zone.*.db /root
echo "You will need to add the SRV/TXT entries in your domain using /root/sample.zone*"
  ;;
  rh7idm02)
    if [ ! -f /root/replica-info-rh7idm02.matrix.lab.gpg ]
    then
      echo "ERROR: You need the replica data from rh7idm01"
      exit 9
    fi
    ADMINPASSWD='Passw0rd'
    # You can't just pass the password in to the command
    cp /root/replica-info-rh7idm02.matrix.lab.gpg /var/lib/ipa/replica-info-rh7idm02.matrix.lab.gpg
    echo -e "${ADMINPASSWD}\n${ADMINPASSWD}" | ipa-replica-install --setup-ca --setup-dns --no-forwarders /var/lib/ipa/replica-info-rh7idm02.matrix.lab.gpg
  ;;
  *)
    echo "DUDE!  This system is not part of the borg"
    exit 0
  ;;
esac

NAMEDCFG=/etc/named.conf
if [ ! -f /etc/rndc.key ]
then
  rndc-confgen -a -c /etc/rndc.key
  restorecon /etc/rndc.key
  chown root:named /etc/rndc.key
  chmod 0640 /etc/rndc.key

cat << EOF >> ${NAMEDCFG}
controls {
  inet 127.0.0.1 port 953
  allow { 127.0.0.1; 10.10.10.1\/24; }
  keys { "rndc-key"; };
};
EOF

  echo "# RNDC KEY" >> ${NAMEDCFG}
  echo "include \"/etc/rndc.key\";" >> ${NAMEDCFG}
  echo  >> ${NAMEDCFG}
fi

MYLINENO=`grep -n managed-keys ${NAMEDCFG} | cut -f1 -d\:`
INSERT=$((MYLINENO+1))
sed -i -e 's/127.0.0.1;/127.0.0.1; 10.10.10.1\/24;/g' ${NAMEDCFG}
sed -i -e 's/localhost/any/g' ${NAMEDCFG}
systemctl restart named 
rndc reload

authconfig --enablemkhomedir --update
echo "$ADMINPASSWD" | kinit 
ipa dnszone-mod --allow-transfer='10.10.10.0/24;127.0.0.1' matrix.lab

# EXAMPLE SYNTAX TO GENERATE HOST LIST FROM NS01
# [root@rh6ns01 ~]# host -l matrix.lab | grep -v rh7idm | sed 's/.matrix.lab//g' | grep -v dhcp | awk '{ print "ipa dnsrecord-add matrix.lab "$1" --a-rec "$4 }'
# [root@rh6ns01 ~]# host -l matrix.lab | egrep -v 'rh7idm|^mat' | sort -k4 | sed 's/10.10.10.//g' | grep -v dhcp | awk '{ print "ipa dnsrecord-add 10.10.10.in-addr.arpa "$4" --ptr-rec "$1"." }'

case `hostname -s` in 
  rh7idm01)
ipa dnsrecord-add matrix.lab gateway --a-rec 10.10.10.1
ipa dnsrecord-add matrix.lab rh6ns01 --a-rec 10.10.10.10
ipa dnsrecord-add matrix.lab rh6sat5 --a-rec 10.10.10.100
ipa dnsrecord-add matrix.lab rh6sam01 --a-rec 10.10.10.101
ipa dnsrecord-add matrix.lab rh7sat6 --a-rec 10.10.10.102
ipa dnsrecord-add matrix.lab ms2k8ad --a-rec 10.10.10.109
ipa dnsrecord-add matrix.lab rh6rhsc --a-rec 10.10.10.110
ipa dnsrecord-add matrix.lab rh6storage --a-rec 10.10.10.111
ipa dnsrecord-add matrix.lab rh6storage01 --a-rec 10.10.10.112
ipa dnsrecord-add matrix.lab rh6storage02 --a-rec 10.10.10.113
ipa dnsrecord-add matrix.lab rh6storage03 --a-rec 10.10.10.114
ipa dnsrecord-add matrix.lab rh6storage04 --a-rec 10.10.10.115
ipa dnsrecord-add matrix.lab rh6nfs --a-rec 10.10.10.116
ipa dnsrecord-add matrix.lab rh6nfs01 --a-rec 10.10.10.117
ipa dnsrecord-add matrix.lab rh6nfs02 --a-rec 10.10.10.118
ipa dnsrecord-add matrix.lab rh7osemst --a-rec 192.168.122.128
ipa dnsrecord-add matrix.lab rh7osemst01 --a-rec 192.168.122.129
ipa dnsrecord-add matrix.lab rh7osemst02 --a-rec 192.168.122.130
ipa dnsrecord-add matrix.lab rh7osemst03 --a-rec 192.168.122.131
ipa dnsrecord-add matrix.lab rh7osetcd01 --a-rec 10.10.10.132
ipa dnsrecord-add matrix.lab rh7osetcd02 --a-rec 10.10.10.133
ipa dnsrecord-add matrix.lab rh7osetcd03 --a-rec 10.10.10.134
ipa dnsrecord-add matrix.lab rh7oseinf01 --a-rec 10.10.10.135
ipa dnsrecord-add matrix.lab rh7oseinf02 --a-rec 10.10.10.136
ipa dnsrecord-add matrix.lab rh7osenod01 --a-rec 10.10.10.137
ipa dnsrecord-add matrix.lab rh7osenod02 --a-rec 10.10.10.138
ipa dnsrecord-add matrix.lab rh6clnt01 --a-rec 10.10.10.201
ipa dnsrecord-add matrix.lab rh7clnt01 --a-rec 10.10.10.202
ipa dnsrecord-add matrix.lab rh6clnt11 --a-rec 10.10.10.203
ipa dnsrecord-add matrix.lab rh7adm01 --a-rec 10.10.10.139
ipa dnsrecord-add matrix.lab rh6clnt01 --a-rec 10.10.10.201
ipa dnsrecord-add matrix.lab rh7clnt01 --a-rec 10.10.10.202
ipa dnsrecord-add matrix.lab rh6clnt11 --a-rec 10.10.10.203
ipa dnsrecord-add matrix.lab rh7clnt11 --a-rec 10.10.10.204
ipa dnsrecord-add 10.10.10.in-addr.arpa 1 --ptr-rec gateway.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 10 --ptr-rec rh6ns01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 100 --ptr-rec rh6sat5.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 101 --ptr-rec rh6sam01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 102 --ptr-rec rh7sat6.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 109 --ptr-rec ms2k8ad.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 110 --ptr-rec rh6rhsc.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 111 --ptr-rec rh6storage.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 112 --ptr-rec rh6storage01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 113 --ptr-rec rh6storage02.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 114 --ptr-rec rh6storage03.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 115 --ptr-rec rh6storage04.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 116 --ptr-rec rh6nfs.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 117 --ptr-rec rh6nfs01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 118 --ptr-rec rh6nfs02.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 128 --ptr-rec rh7osemst.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 129 --ptr-rec rh7osemst01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 130 --ptr-rec rh7osemst02.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 131 --ptr-rec rh7osemst03.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 132 --ptr-rec rh7osetcd01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 133 --ptr-rec rh7osetcd02.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 134 --ptr-rec rh7osetcd03.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 135 --ptr-rec rh7oseinf01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 136 --ptr-rec rh7oseinf02.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 137 --ptr-rec rh7osenod01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 138 --ptr-rec rh7osenod02.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 139 --ptr-rec rh7adm01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 201 --ptr-rec rh6clnt01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 202 --ptr-rec rh7clnt01.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 203 --ptr-rec rh6clnt11.matrix.lab.
ipa dnsrecord-add 10.10.10.in-addr.arpa 204 --ptr-rec rh7clnt11.matrix.lab.

  ;;
esac

exit 0

# Appendix to meld Satellite 6 in to the fold...
  ## On RH7IDM01...
echo Passw0rd | kinit admin
ipa host-add --desc="Satellite 6" --locality="Washington, DC" --location="LaptopLab" --os="Red Hat Enterprise Linux Server 7" --password=Passw0rd rh7sat6.matrix.lab
ipa service-add HTTP/rh7sat6.matrix.lab@matrix.lab




dig SRV _kerberos._tcp.matrix.lab | grep -v \;
dig SRV _ldap._tcp.matrix.lab | grep -v \;

# Example DNS update
; ldap servers
_ldap._tcp		IN SRV 0 100 389	rh7idm01
_ldap._tcp		IN SRV 0 90  389	rh7idm02

;kerberos realm
_kerberos		IN TXT MATRIX.LAB

; kerberos servers
_kerberos._tcp		IN SRV 0 100 88		rh7idm01
_kerberos._udp		IN SRV 0 100 88		rh7idm01
_kerberos-master._tcp	IN SRV 0 100 88		rh7idm01
_kerberos-master._udp	IN SRV 0 100 88		rh7idm01
_kpasswd._tcp		IN SRV 0 100 464	rh7idm01
_kpasswd._udp		IN SRV 0 100 464	rh7idm01
_kerberos._tcp          IN SRV 0 90 88         rh7idm02
_kerberos._udp          IN SRV 0 90 88         rh7idm02
_kerberos-master._tcp   IN SRV 0 90 88         rh7idm02
_kerberos-master._udp   IN SRV 0 90 88         rh7idm02
_kpasswd._tcp           IN SRV 0 90 464        rh7idm02
_kpasswd._udp           IN SRV 0 90 464        rh7idm02

; CNAME for IPA CA replicas (used for CRL, OCSP)
ipa-ca			IN A			10.10.10.121
ipa-ca			IN A			10.10.10.122
