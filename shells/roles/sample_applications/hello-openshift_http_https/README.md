HELLO OPENSHIFT WITH HTTP/HTTPS
---

This script use docker image to deploy so it is useful when OCP does not have accessibility to github.com 

##SCRIPT
- deploy-helloWorld.sh

##Usage

	deploy-helloWorld.sh <PROJECT_NAME> <HOST_NAME> <SIGNER_KEY> <SIGNER_CERT> <SIGNER_SERIAL>

	Example
	deploy-helloWorld.sh helloworld helloworld.cloudapps.example.com  /etc/origin/master/ca.key /etc/origin/master/ca.crt /etc/origin/master/ca.serial.txt
	deploy-helloWorld.shhelloworld helloworld.cloudapps.example.com  ./ca.key ./ca.crt ./ca.serial.txt