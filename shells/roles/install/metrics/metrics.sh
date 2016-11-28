

. $CONFIG_PATH/ose_config.sh

#Recheck we are in openshift-infra
oc project openshift-infra


#Create metrics sa
oc create -f - <<API
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metrics-deployer
secrets:
- name: metrics-deployer
API


#Add edit role to metrics sa(It allow this sa to edit configuration in openshift-infra project)
oadm policy add-role-to-user edit \
  system:serviceaccount:openshift-infra:metrics-deployer


#Create heapster sa
#oc create -f - <<API
#apiVersion: v1
#kind: ServiceAccount
#metadata:
#  name: heapster
#secrets:
#- name: heapster
#API

#Add edit role to heapster sa (It allow this sa to read configuration around all cluster)
oadm policy add-cluster-role-to-user cluster-reader \
  system:serviceaccount:openshift-infra:heapster

#Use self signed certs
oc secrets new metrics-deployer nothing=/dev/null

# Deploy metrics-deployer
if [[ -e /usr/share/openshift/examples/infrastructure-templates/enterprise/metrics-deployer.yaml ]]
then
     oc process -f /usr/share/openshift/examples/infrastructure-templates/enterprise/metrics-deployer.yaml -v  HAWKULAR_METRICS_HOSTNAME=hawkular.${subdomain},USE_PERSISTENT_STORAGE=false,IMAGE_PREFIX="sourcehub.ao.dcn:5000/openshift3/",IMAGE_VERSION=latest   | oc create -f -
else
     oc process -f metrics-deployer.yaml -v  HAWKULAR_METRICS_HOSTNAME=hawkular.${subdomain},USE_PERSISTENT_STORAGE=false  | oc create -f -
fi
