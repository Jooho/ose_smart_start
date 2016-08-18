#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.21
# Purpose: This is configuration file for base images
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160721   jooho    Create
#        20160816   jooho    Add xpaas image list
#        20160818   jooho    To get imageStream name/tag, add new logic with jq
#



export base_images="
    registry.access.redhat.com/openshift3/ose-haproxy-router \
    registry.access.redhat.com/openshift3/ose-deployer \
    registry.access.redhat.com/openshift3/ose-sti-builder \
    registry.access.redhat.com/openshift3/ose-docker-builder \
    registry.access.redhat.com/openshift3/ose-pod \
    registry.access.redhat.com/openshift3/ose-docker-registry \
    registry.access.redhat.com/openshift3/ose-recycler \
    registry.access.redhat.com/openshift3/ose-keepalived-ipfailover \
    registry.access.redhat.com/openshift3/ose-f5-router"

export logging_metrics_images="
    registry.access.redhat.com/openshift3/logging-deployment \
    registry.access.redhat.com/openshift3/logging-elasticsearch \
    registry.access.redhat.com/openshift3/logging-kibana \
    registry.access.redhat.com/openshift3/logging-fluentd \
    registry.access.redhat.com/openshift3/logging-auth-proxy \
    registry.access.redhat.com/openshift3/metrics-deployer \
    registry.access.redhat.com/openshift3/metrics-hawkular-metrics \
    registry.access.redhat.com/openshift3/metrics-cassandra \
    registry.access.redhat.com/openshift3/metrics-heapster"

#rhel7 image is using different name for each version
# If there is no jq on system, you can download it
# ftp://195.220.108.108/linux/fedora/linux/releases/22/Everything/x86_64/os/Packages/j/jq-1.3-4.fc22.x86_64.rpm

export builder_images=$(cat ./imageStream/image-streams-rhel7.json.${ose_version}|grep registry.access|cut -d: -f2|sed 's/"//g')

export fis_images=$(cat ./imageStream/fis-image-streams.json.${ose_version}|grep registry.access|cut -d: -f2|sed 's/,//g'|sed 's/"//g')
export fis_tags=$(cat ./imageStream/fis-image-streams.json.${ose_version} |jq '.items[].spec | {dockerImage: .dockerImageRepository, tag : .tags[].name}' |jq .|grep -v dockerImage |sed "s/[{,},\",tag:]//g"|sort|uniq)

export jboss_images=$(cat ./imageStream/jboss-image-streams.json.${ose_version}|grep registry.access|cut -d: -f2|sed 's/,//g'|sed 's/"//g')
export jboss_tags=$(cat ./imageStream/jboss-image-streams.json.${ose_version} |jq '.items[].spec | {dockerImage: .dockerImageRepository, tag : .tags[].name}' |jq .|grep -v dockerImage |sed "s/[{,},\",tag:]//g"|sort|uniq)


export default_registry="registry.access.redhat.com"
export new_docker_registry_url="sourcehub.ao.dcn:5000"

