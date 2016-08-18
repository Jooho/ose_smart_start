#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.08.17
# Purpose: This script change docker registry tag to specific version according to OSE version
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160817   jooho  Create
#
#
#
##############################################################################

. $CONFIG_PATH/ose_config.sh

#If docker registry use latest as a tag, it should be changed to specific version

oc patch dc/docker-registry --api-version=v1 -p '{"spec": {"template": {"spec": {"containers":[{
    "name":"registry",
    "image": "${new_docker_registry_url}/openshift3/ose-docker-registry:${image_version}"
  }]}}}}'

