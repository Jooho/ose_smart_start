#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.22
# Purpose: This script clean ImageStream in openshift project and create new IS with new docker-regsistry 
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160722   jooho   Create
#
#
#

##############################################################################

. $CONFIG_PATH/ose_config.sh


sed "s/registry.access.redhat.com/${new_docker_registry_url}/g" ./image-streams-rhel7.json>./image-streams-rhel7-new.json 
sed "s/registry.access.redhat.com/${new_docker_registry_url}/g" ./jboss-image-streams.json > ./jboss-image-streams-new.json
sed "s/registry.access.redhat.com/${new_docker_registry_url}/g" ./fis-image-streams.json > ./fis-image-streams-new.json


for is in $(cat is_delete_list.txt)
do
   oc delete is $is -n openshift
done

oc create -f ./image-streams-rhel7-new.json -n openshift
oc create -f ./jboss-image-streams-new.json -n openshift
oc create -f ./fis-image-streams-new.json -n openshift

rm -rf *new.json
