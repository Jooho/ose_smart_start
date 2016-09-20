#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Replace default certificate which is provided by Openshift to custom cert for web console.
#          This script set up necessary environment in order to install Openshift
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  parameterized variables
#
#

. $CONFIG_PATH/ose_config.yaml

# Back up master-config.yaml
# Check the *.cer and *.key to /etc/origin/master directory on ALL master nodes

cp /etc/origin/master/master-config.yaml /etc/origin/master/master-config.yaml-`date +%F-%H%M`_before_change_webconsole_cert"

cat << EOF > webconsole.yaml

    namedCertificates:
     - certFile: api_${env}_cloudapps_ao_dcn.crt
       keyFile: api_${env}_cloudapps_ao_dcn.key
       names:
       - "api.${env}.cloudapps.ao.dcn"
EOF

mv /etc/origin/master/master-config.yaml /etc/origin/master-config.yaml.before_webconsole

awk '/maxRequestsInFlight:/{printf $0; while(getline line<"webconsole.yaml"){print line};next}1'  /etc/origin/master-config.yaml.before_webconsole > /etc/origin/master/master-config.yaml


# Restart atomic-openshift-master-api
export correct_answer="false"
while [ $correct_answer == "false" ]
do
        echo "master-config.yaml file is updated properly?(y/n)" 
        read update_master_configuration
        if [[ $update_master_configuration == "y" ]]; then
           for HOST in `egrep "${master_config}" ${host_file_path}/${host_file} | awk '{ print $1 }' `
           do
                echo "Restarting master server : $HOST"
                ssh -q root@$HOST "systemctl restart atomic-openshift-master-api"
           done
           correct_answer=true
        else
           echo "Please choose y or n only."
        fi
done



# There are 2 locations that need the following...
# At the top of the config file, update ^assetConfig
# At the bottom of the config file, update ^servingInfo
#   maxRequestsInFlight: 500  << BETWEEN HERE
#  namedCertificates:
#  - certFile: api_${env}_cloudapps_ao_dcn.crt
#    keyFile: api_${env}_cloudapps_ao_dcn.key
#    names:
#    - "api.${env}.cloudapps.ao.dcn"
#  requestTimeoutSeconds: 3600  << AND HERE
# Update masterPublicURL, assetConfig.publicURL, and oauthConfig.assetPublicURL
#

#** Update atomic-openshift-master-api.yaml on all master nodes **
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#    maxRequestsInFlight: 0 << BETWEEN HERE
#    namedCertificates:
#     - certFile: api_${env}_cloudapps_ao_dcn.crt
#       keyFile: api_${env}_cloudapps_ao_dcn.key
#       names:
#       - "api.${env}.cloudapps.ao.dcn"
#    requestTimeoutSeconds: 0 << AND HERE
# Update masterPublicURL, assetConfig.publicURL, and oauthConfig.assetPublicURL
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#** Check command
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#egrep 'URL|api.${env}|api_${env}' /etc/origin/master/master-config.yaml
#  logoutURL: ""
#  masterPublicURL: https://api.${env}.cloudapps.ao.dcn:8443
#  publicURL: https://api.${env}.cloudapps.ao.dcn:8443/console/
#  - certFile: api_${env}_cloudapps_ao_dcn.crt
#    keyFile: api_${env}_cloudapps_ao_dcn.key
#    - "api.${env}.cloudapps.ao.dcn"
#masterPublicURL: https://api.${env}.cloudapps.ao.dcn:8443
#  assetPublicURL: https://api.${env}.cloudapps.ao.dcn:8443/console/
#  masterPublicURL: https://aoappd-cluster.${env}.cloudapps.ao.dcn:8443
#  masterURL: https://aoappd-cluster.${env}.cloudapps.ao.dcn:8443
#  - certFile: api_${env}_cloudapps_ao_dcn.crt
#    keyFile: api_${env}_cloudapps_ao_dcn.key
#    - "api.${env}.cloudapps.ao.dcn"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


