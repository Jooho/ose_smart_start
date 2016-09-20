#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.14
# Purpose: Deploy Router
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   Created
#        20160805   jooho   fix condition error when sbx|pnp is specified, the second script should run
#
#
#

. $CONFIG_PATH/ose_config.sh

CA=/etc/origin/master

# Deploy the routers
if [[ $(echo ${env} | egrep "sbx|pnp" |wc -l) == 0 ]]
then

oadm router --replicas=1 --stats-password='os3@dm1n' \
    --config=/etc/origin/master/admin.kubeconfig  \
	  --credentials=/etc/origin/master/openshift-router.kubeconfig \
	      --service-account=router --selector=${infra_selector}
else

# Create SSL pem file using default ca file for router.
echo "Create SSL pem file using default ca file for router : $CA/router.pem"
cat $CA/star_${env}_cloudapps_ao_dcn.crt $CA/cloudapps_ao_dcn.key  /etc/pki/ca-trust/source/anchors/US_COURT_Private.crt > $CA/router.pem

oadm router --replicas=1 --default-cert=$CA/router.pem ---stats-password='os3@dm1n' \
    --config=/etc/origin/master/admin.kubeconfig  \
	  --credentials=/etc/origin/master/openshift-router.kubeconfig \
	    #--images='registry.access.redhat.com/openshift3/ose-haproxy-router:${version}' \
	      --service-account=router --selector=${infra_selector}
fi

#if you want to specify specific version
# --images='registry.access.redhat.com/openshift3/ose-haproxy-router:${version}' \
