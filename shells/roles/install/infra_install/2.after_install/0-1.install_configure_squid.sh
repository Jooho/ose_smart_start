#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.14
# Purpose: This script install squid package on master/infra nodes and change configuration. Before executing it, you need
#          to update this script according to your environment.
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   update comment
#        20160802   jooho   jolokia port open
#        20160802   jooho   comment out ssl_ports/Saft_ports 
#                           add Block_ports(3128)
#
#
#

. $CONFIG_PATH/ose_config.sh


sudo yum -y install squid
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

cat << EOF > /etc/squid/squid.conf
# This is a minimal Squid config for use by OpenShift pods
# Only access from RFC1918 addresses is allowed
# All request caching is disabled
#
# http_access lines control what can be accessed.
# never_direct/allow_direct lines control how a resource is accessed.

# These control access to Squid

# Define internal domains below
acl direct-connect dstdomain .dcn

# Safe port list
#acl SSL_ports port 443
#acl SSL_ports port 8443
#acl SSL_ports port 8778
#acl SSL_ports port 10250

#acl Safe_ports port 80          # http
#acl Safe_ports port 443         # https
#acl Safe_ports port 1936        # haproxy stats
#acl Safe_ports port 5000        # docker
#acl Safe_ports port 8443        # https
#acl Safe_ports port 8778        # jolokia
#acl Safe_ports port 10250       # kuberlet

acl Block_ports port 3128        #squid

# Deny requests to certain unsafe ports
#http_access deny !Safe_ports
http_access deny Block_ports


# This list can be tightened to the IP address ranges for pods and host VM's.
acl localnet src 10.0.0.0/8    # RFC1918 possible internal network
acl localnet src 172.16.0.0/12    # RFC1918 possible internal network
acl localnet src 192.168.0.0/16    # RFC1918 possible internal network

# allow access to services associated with default project
acl svc_networks dstdomain .default.svc.cluster.local
acl svc_networks dstdomain .openshift.svc.cluster.local
#
# Block access to services associated with other projects
acl ose_internal dstdomain .cluster.local
#
# Assumes default OpenShift configuration
acl ose_networks dst 172.30.0.0/16
acl ose_networks dst 10.1.0.0/16

# These are used to route requests to internal resources assuming use
# of RFC1918 addresses
acl our_networks dst 10.0.0.0/8
acl our_networks dst 172.16.0.0/12
acl our_networks dst 192.168.0.0/16

acl CONNECT method CONNECT

http_access deny manager

# Squid normally listens to port 3128
http_port 3128

# Disable all caching
cache deny all
digest_generation off

# These control who can use the proxy, both by source IP and target URL
#
http_access allow localhost
http_access allow localnet svc_networks
http_access deny ose_internal ose_networks
http_access allow localnet all

# And finally deny all other access to this proxy
http_access deny all

# These control the routing of requests
#
always_direct allow svc_networks
always_direct allow our_networks
always_direct allow direct-connect
#
never_direct allow all

cache_peer_access https_proxy deny CONNECT
cache_peer ${squid_http_proxy_ip} parent ${squid_http_proxy_port} 0 no-query no-digest name=https_proxy

# Added for the McAfee Web Gateway (Proxy)
forwarded_for delete

EOF

systemctl enable squid
systemctl restart squid 

exit 0

