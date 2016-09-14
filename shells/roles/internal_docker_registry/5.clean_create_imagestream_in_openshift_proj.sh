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

calc() { awk "BEGIN{print $*}"; }

sed "s/registry.access.redhat.com/${new_docker_registry_url}/g" ${CONFIG_PATH}/imageStream/image-streams-rhel7.json.${ose_version}>./image-streams-rhel7-new.json 
sed "s/registry.access.redhat.com/${new_docker_registry_url}/g" ${CONFIG_PATH}/imageStream/jboss-image-streams.json.${ose_version} > ./jboss-image-streams-new.json
sed "s/registry.access.redhat.com/${new_docker_registry_url}/g" ${CONFIG_PATH}/imageStream/fis-image-streams.json.${ose_version} > ./fis-image-streams-new.json

echo "new : $ose_version"
echo "old : $old_ose_version"
for is in $(cat is_delete_list_${old_ose_version}.txt)
#for is in $(cat is_delete_list_${ose_version}.txt)
do
   oc delete is $is -n openshift
done

oc create -f ./image-streams-rhel7-new.json -n openshift
oc create -f ./jboss-image-streams-new.json -n openshift
oc create -f ./fis-image-streams-new.json -n openshift

#rm -rf *new.json
