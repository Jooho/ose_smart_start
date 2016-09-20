#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.06.02
# Purpose: Update Proxy information to atomic-openshift-master-api / atomic-openshift-master-controllers /  atomic-openshift-node / docker
#          
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho  parameterized variables:infra_ip_list
#
#
#


. $CONFIG_PATH/ose_config.sh

# Create the SVC on the Master to provide the endpoints
cat << EOF > squid_svc.json
apiVersion: v1
kind: Service
metadata:
  name: squid
  namespace: default
spec:
  clusterIP: ${squid_svc_ip}
  ports:
  - name: squid
    port: 3128
    protocol: TCP
    targetPort: 3128
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
EOF
oc create -f ./squid_svc.json


infra_ip_list=$(get_specific_hosts_ips infra ip )

cat <<EOA > squid_endpoints.json
apiVersion: v1
kind: Endpoints
metadata:
  name: squid
  namespace: default
subsets:
- addresses:
EOA

for ip in $infra_ip_list
do
 echo "  - ip: $ip" >>  squid_endpoints.json
done

cat <<EOB >> squid_endpoints.json
  ports:
  - name: squid
    port: 3128
    protocol: TCP
EOB

oc create -f ./squid_endpoints.json

oc get svc
oc get ep

exit 0


