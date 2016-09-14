#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Expose docker registry service and create cert folder
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  change structure.
#
#
#

. $CONFIG_PATH/ose_config.sh

cat << EOF > docker_registry_route.yaml
apiVersion: v1
kind: Route
metadata:
  name: registry
spec:
  host: ${docker_registry_route_url}
  to:
    kind: Service
    name: docker-registry 
  tls:
    termination: passthrough 

EOF

oc create -f ./docker_registry_route.yaml
#rm -rf docker_registry_route.yaml


