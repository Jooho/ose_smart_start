. ../../config//ose_config.sh

#Download base images 
infra_nodes=$(oc get node|grep infra|awk '{print $1}')
app_nodes=$(oc get node|grep app|awk '{print $1}')

if [[ $(hostname) == ${ansible_operation_vm} ]]
then
   for infra_node in $infra_nodes
   do
    ssh root@$infra_node \
       "docker pull registry.access.redhat.com/openshift3/ose-haproxy-router:${image_version}  ;
       docker pull registry.access.redhat.com/openshift3/ose-deployer:${image_version} ;
       docker pull registry.access.redhat.com/openshift3/ose-pod:${image_version} ;
       docker pull registry.access.redhat.com/openshift3/ose-docker-registry:${image_version}" ;
   done
  
   for app_node in $app_nodes
   do
     ssh root@$app_node \
       "docker pull registry.access.redhat.com/openshift3/ose-deployer:${image_version};
        docker pull registry.access.redhat.com/openshift3/ose-sti-builder:${image_version} ; \
        docker pull registry.access.redhat.com/openshift3/ose-docker-builder:${image_version} ; \
        docker pull registry.access.redhat.com/openshift3/ose-pod:${image_version} ; \
        docker pull registry.access.redhat.com/openshift3/ose-keepalived-ipfailover:${image_version} ; \
        docker pull registry.access.redhat.com/openshift3/ruby-20-rhel7 ; \
        docker pull registry.access.redhat.com/openshift3/mysql-55-rhel7 ; \
        docker pull openshift/hello-openshift:v1.0.6"
   done
else
  echo "This script is designed to execute on master server which executed ansible script"
fi
