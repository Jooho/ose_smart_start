#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.14
# Purpose: This script help execute remote shell
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   Created
#
#
#
# Included scripts:
#
#  - 3-1.change_webconsole_cert.sh  
#   Description :
#          Replace default certificate which is provided by Openshift to custom cert for web console.
#          This script set up necessary environment in order to install Openshift
#   Execute Host:
#        Master nodes


. ${CONFIG_PATH}/ose_config.sh

export correct_answer="false"
while [ $correct_answer == "false" ]
do
 	echo "Have you prepared certificates for api/star(y/n)?"
	echo "Note: All certs should be under /etc/origin/master" 
        read exist_cert
        if [[ $exist_cert == "y" ]]; then
                echo "OK.. You can move on next step"
                echo ""
           	correct_answer=true
        else
          	echo "Please prepare certificate first (../utils/generate_certReq.sh)"
 	  	exit 9
        fi
done


for HOST in `egrep "${master_prefix}" ${host_file_path}/${host_file} | awk '{ print $1 }' ` 
do  
    ssh -q root@${HOST} "sh ${ose_temp_dir}/${after_install_path}/3-1.change_webconsole_cert.sh
done

# Test
echo ""
echo "**TEST**"
echo "echo | openssl s_client -connect api.${env}.${subdomain}:8443 -servername api.${env}.${subdomain} | grep CN"

#  The curl will fail until you import the Customer Certs
echo "The curl will fail until you import the Customer Certs"
echo "curl -v https://${host}.${env}.${subdomain}:8443"
