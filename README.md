OpenShift Container Platform Smart Start
---

This project is started to gather useful OCP commands for Smart Start. During real engagement, this script can be used from pre-requisite to deploy metrics. Such as certs files and password must be managed in private repository. Hence, it provides the way to separate some private stuff from main project using custom project.

In order to use this script, configuration files should be updated according to your environment (NOTE: ad-hoc role does not need to update configuration).

**Configration files**

- ose_config.sh.default 
	- Main configuration file that has most values
- nfs_config.sh.default 
	-  LVM/NFS related values
- pv_config.sh.default  
	- PV/PVC related values
- image_config.sh       
	- External docker registry related values in disconnected environment

It is recommended to use independent vm only for Ansible playbook. Moreover, if it is possible, root use is prefered for installation OCP.  
## Ready to use script 
	# git clone https://github.com/jooho/ose_smart_start
	
	# cd ose_smart_start
	
	# source getReady.sh


##ROLE
Role concept is from ansible. Each role have specific object based on the configuration information. Therefore, it is required to update configuration files before executing scripts in roles.
### INSTALL
	- INFRA_INSTALL
	- ROUTER
	- DOCKER REGISTRY
	- METRIC
	- PERSISTENT VOLUME
### AD-HOC	
	- cert
	- nfs	
	- pv
	- route
	- router		
### SAMPLE-APPLICATION
	- eap_ssl
	- hello-openshift_http_https 
    - sinatra_http
    - sinatra_https
    
### INTERNAL_DOCKER_REGISTRY	
	- Update official images
		
### Validation
	- validation_dns_lookup.sh



