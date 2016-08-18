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
#
#



export base_images="
    registry.access.redhat.com/openshift3/ose-haproxy-router \
    registry.access.redhat.com/openshift3/ose-deployer \
    registry.access.redhat.com/openshift3/ose-sti-builder \
    registry.access.redhat.com/openshift3/ose-docker-builder \
    registry.access.redhat.com/openshift3/ose-pod \
    registry.access.redhat.com/openshift3/ose-docker-registry"

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
export builder_images=$(cat image-streams-rhel7.json.${ose_version}|grep registry.access|cut -d: -f2|sed 's/"//g')

export xpaas_images="
    registry.access.redhat.com/jboss-fuse-6/fis-java-openshift \
    registry.access.redhat.com/jboss-fuse-6/fis-karaf-openshift \
    registry.access.redhat.com/jboss-datagrid-6/datagrid65-openshift \
    registry.access.redhat.com/jboss-amq-6/amq62-openshift \
    registry.access.redhat.com/jboss-eap-6/eap64-openshift \
    registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat7-openshift \
    registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift \
    registry.access.redhat.com/jboss-decisionserver-6/decisionserver62-openshift"

export default_registry="registry.access.redhat.com"
export new_docker_registry_url="sourcehub.ao.dcn:5000"

