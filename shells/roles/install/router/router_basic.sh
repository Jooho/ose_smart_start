. $CONFIG_PATH/config/ose_config.sh

CA=/etc/origin/master

# Deploy the routers
oadm router --replicas=1 --stats-password='os3@dm1n' \
    --config=/etc/origin/master/admin.kubeconfig  \
	  --credentials=/etc/origin/master/openshift-router.kubeconfig \
	    #--images='registry.access.redhat.com/openshift3/ose-haproxy-router:${version}' \
	      --service-account=router --selector=${infra_selector}

