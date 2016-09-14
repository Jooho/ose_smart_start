#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.23
# Purpose: Replace default login page to custom one
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho  parameterized variables
#
#
#

. ${CONFIG_PATH}/ose_config.sh


## UPDATE THE WEB LOGIN VERBIAGE
cat << EOA > change_login_page.sh
cd /etc/origin/master/
oadm create-login-template > /etc/origin/master/login-template.html
chmod 0644  /etc/origin/master/login-template.html
sed -i -e 's/Login/OpenShift Enterprise Login/g' /etc/origin/master/login-template.html
sed -i -e '/<\/body\>/d' /etc/origin/master/login-template.html
sed -i -e '/<\/html\>/d' /etc/origin/master/login-template.html

cat << EOB >> /etc/origin/master/login-template.html
<h2>  Welcome to OpenShift Enterprise </h2>
<br>
<pre>

  U.S. GOVERNMENT SYSTEM
  ----------------------

  This is a U.S. Government system. Unauthorized entry into or use of
  this system is prohibited and subject to prosecution under Title 18 of
  the U.S. Code or other sanctions.  All activities and access attempts are
  logged.  All data on or replicated from this system may be reviewed in
  accordance with Judiciary policies.

  LOG OFF IMMEDIATELY if you do not agree to these conditions.

  ----------------------

</pre>

  </body>

</html>
EOB

EOA


for HOST in `egrep "${master_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
do
    scp change_login_page.sh  root@$HOST:/etc/origin/master/.
    ssh -q root@$HOST "cp /etc/origin/master/master-config.yaml /etc/origin/master/master-config.yaml-`date +%F-%H%M`_before_change_login_page"
    ssh -q root@$HOST "sh /etc/origin/master/change_login_page.sh"
done

cat << EOF
** Update atomci-openshift-master-api.yaml on all master nodes **
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
oauthConfig:
   ...
   templates:
    login: /etc/origin/master/login-template.html
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF

# Restart atomic-openshift-master-api
export correct_answer="false"
while [ $correct_answer == "false" ]
do
        echo "Have you update configuration on all Master Nodes?(y/n)"
        read update_master_configuration
        if [[ $update_master_configuration == "y" ]]; then
           for HOST in `egrep "${master_prefix}" $CONFIG_PATH/${host_file} | awk '{ print $1 }' `
           do
                echo "Restarting master server : $HOST"
                ssh -q root@$HOST "systemctl restart atomic-openshift-master-api"
           done
           correct_answer=true
        else
           echo "Please choose y or n only. If you don't update master-config.yaml, you have to do it before typing 'y'"
        fi
done

