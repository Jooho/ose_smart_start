. ../ose_config.sh

if [[ $(hostname) == ${ansible_operation_vm} ]]
then

oadm registry --service-account=registry --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='registry.access.redhat.com/openshift3/ose-${component}:${version}' --selector="${infra_selector}"

else
  echo "This script is designed to execute on master server which executed ansible script"
fi
