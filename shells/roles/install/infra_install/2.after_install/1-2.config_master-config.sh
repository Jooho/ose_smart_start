#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.11
# Purpose: Update master-config.yaml for LDAP authentication
#

# Related file :
#       ldap.yaml
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   add awk to make updating master-config.yaml automatically
#
#
#
# TO-DO  : it should be done with ansible script
#openshift_master_identity_providers=[{'name': 'my_ldap_provider', 'challenge': 'true', 'login': 'true', 'kind': 'LDAPPasswordIdentityProvider', 'attributes': {'id': ['dn'], 'email': ['mail'], 'name': ['cn'], 'preferredUsername': ['uid']}, 'bindDN': 'uid=OpenShiftAdmin,ou=TSO,ou=applications,O=USCOURTS,C=US', 'bindPassword': 'aqNWDDKk', 'ca': '', 'insecure': 'false', 'url': 'ldap://localhost:389/o=USCOURTS,c=US?uid'}]

. $CONFIG_PATH/ose_config.sh

sed -i -e 's/deny_all/Jenie/g' /etc/origin/master/master-config.yaml
sed -i -e 's/DenyAllPasswordIdentityProvider/LDAPPasswordIdentityProvider/g' /etc/origin/master/master-config.yaml
sed -i -e 's/subdomain:  ""/subdomain:  "${subdomain}"/g' /etc/origin/master/master-config.yaml

mv /etc/origin/master/master-config.yaml /etc/origin/master-config.yaml.before_ldap

awk '/identityProviders:/{printf $0; while(getline line<"1-3.ldap.yaml"){print line};next}1'  /etc/origin/master-config.yaml.before_ldap > /etc/origin/master/master-config.yaml 

## Update LDAP auth (/etc/origin/master/master-config.yaml
#  identityProviders: (BETWEEN HERE)
#  - challenge: true
#    name: jenie
#    login: true
#    provider:
#      apiVersion: v1
#      kind: LDAPPasswordIdentityProvider
#      attributes:
#        id:
#        - dn
#        email:
#        - mail
#        name:
#        - cn
#        preferredUsername:
#        - uid
#      bindDN: uid=OpenShiftAdmin,ou=TSO,ou=applications,O=USCOURTS,C=US
#      bindPassword: "aqNWDDKk"
#      insecure: false
#      ca: ""
#      url: "ldaps://localhost:389/o=USCOURTS,c=US?uid"
#  masterCA: ca.crt  (AND HERE)

