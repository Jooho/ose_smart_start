#!/bin/bash
#
# @(#)$Id$
#
# Purpose:  Simple Script to subscribe hosts to Satellite and OSE
#  Author:  jradtke@redhat.com / joshib@ao.uscourts.gov
#    Date:  20160101
#   Notes:  This functionality will likely be replace by alternate methods
#           once Satellite 6 is a more solidified solution in the ENV.
#
# History:
#          Date   |  who  |  Changes  
#========================================================================
#        20160711   jooho  parameterized variables 
#
#
#

# subscription-manager list --available --all | grep -n5 EPEL
#EPEL_POOL_ID="8a22934550f222f10150f23244240002"

rm /etc/yum.repos.d/local.repo
mv /etc/sysconfig/rhn/systemid /etc/sysconfig/rhn/.systemid
subscription-manager clean
yum -y localinstall http://${satellite_server}/pub/katello-ca-consumer-latest.noarch.rpm
subscription-manager register --org="${satellite_org}" --activationkey="OSEv3.1" --release=7Server
yum -y install katello-agent
katello-package-upload
yum -y update
exit 0

# If the Activation Key does not work, you can...
subscription-manager register --org="${satellite_org}" --environment="Library" --username='test' --password='password' --release=7.2 --auto-attach --force
subscription-manager repos --disable="*" --enable rhel-7-server-rpms --enable rhel-7-server-satellite-tools-6.1-rpms --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-ose-3.2-rpms

