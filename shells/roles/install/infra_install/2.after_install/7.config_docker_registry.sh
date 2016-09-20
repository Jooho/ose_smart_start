#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Deploy docker registry/ Attach NFS to docker registry / Change service IP / Create SSL, apply it and create cert folders for docker
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   update comments
#
#
#

# Deploy docker registry
../../docker_registry.sh

# Attach NFS to docker registry 
../../docker_registry_attach_nfs.sh

# Change service IP 
../../docker_registry_change_svc_ip.sh

# Create SSL, apply it and create cert folders for docker
../../docker_registry_ssl.sh
