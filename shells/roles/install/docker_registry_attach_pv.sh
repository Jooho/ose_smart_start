. ../ose_config.sh

if [[ $(hostname) == ${ansible_operation_vm} ]]
then

   oc volume deploymentconfigs/docker-registry --add --name=registry-storage -t pvc --claim-name=registry-claim --overwrite

   oc get -o yaml svc docker-registry |  sed 's/\(sessionAffinity:\s*\).*/\1ClientIP/' |  oc replace -f -

else
  echo "This script is designed to execute on master server which executed ansible script"
fi
