. ../ose_config.sh

if [[ $(hostname) == ${ose_cli_operation_vm} ]]
then

oadm registry --service-account=registry --config=/etc/origin/master/admin.kubeconfig --credentials=/etc/origin/master/openshift-registry.kubeconfig --images='192.168.200.108:5000/openshift3/ose-${component}:${version}' --selector="${infra_selector}"

else
  echo "This script is designed to execute on master server which executed ansible script"
fi
