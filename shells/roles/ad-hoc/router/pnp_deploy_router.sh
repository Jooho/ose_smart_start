#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.18
# Purpose: This script deploy pnp router directly without any configuration
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160718   jooho   Create
#
#
#

CA=/etc/origin/master

cat $CA/star_pnp_cloudapps_ao_dcn.crt $CA/star_pnp_cloudapps_ao_dcn.key  $CA/US_COURT_Private.crt > $CA/star_pnp_cloudapps_ao_dcn.pem

oadm router --replicas=2 --stats-password='os3@dm1n' --default-cert=$CA/star_pnp_cloudapps_ao_dcn.pem --credentials=/etc/origin/master/openshift-router.kubeconfig --service-account=router --selector=region=infra,zone=pnp 

