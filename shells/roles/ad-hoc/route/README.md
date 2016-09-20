Route
---

##Create tls route json file.
This script help create route json file with crt/key/caCrt file.

###Usage
	generate_route.sh <HOST_NAME> <SVC_NAME> <PRIVATE_KEY_FILE> <CERT_FILE> <CA_CERT_FILE>
	
	Example
	generate_route.sh helloworld.cloudapps.example.com hello-openshift private.key cert.crt /etc/origin/master/ca.crt "
	generate_route.sh helloworld.cloudapps.example.com hello-openshift private.key cert.crt ./ca.crt "
