#Install the following base packages:

yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion 

#Update the system to the latest packages:

yum update

#Install the following package, which provides OpenShift utilities and pulls in other tools required by the quick and
#advanced installation methods, such as Ansible and related configuration files:

yum install atomic-openshift-utils

# if docker is not installed, it will install it.
yum install docker

#Docker storage
# ansible role : ose_docker_configure

#Check if Docker is running:

systemctl is-active docker

#If Docker has not yet been started on the host, enable and start the service:

systemctl enable docker
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl restart docker

# docker log max 
--log-opt max-size=1M --log-opt max-file=3
