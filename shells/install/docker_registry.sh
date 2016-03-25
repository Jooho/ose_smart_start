. ../ose_config.sh

openshift_registry_selector=$(grep openshift_registry_selector /etc/ansible/hosts | grep -v ^# |cut -d"'" -f2)

if [[ $(hostname) == ${ansible_operation_vm} ]]
then

oadm registry --service-account=registry --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --selector="$openshift_registry_selector"

else
  echo "This script is designed to execute on master server which executed ansible script"
fi
