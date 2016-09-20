EAP SSL
---

This script deploy EAP with SSL which is self signed certificate.

##SCRIPT
- eap-passthrough-tls-cert-generater.sh


##Usage
~~~
#   ./eap-passthrough-tls-cert-generater.sh PROJECT_NAME
#
# (Sample)
# [root@aoappd-w-dev001 route-egde-reencrypte-passthrough]# ./eap-passthrough-tls-cert-generater.sh test
#   What is your first and last name?
#    [Unknown]:  Red Hat
#   What is the name of your organizational unit?
#    [Unknown]:  Red Hat
#   What is the name of your organization?
#    [Unknown]:  Red Hat
#   What is the name of your City or Locality?
#    [Unknown]:  Toronto
#   What is the name of your State or Province?
#    [Unknown]:  ON
#   What is the two-letter country code for this unit?
#    [Unknown]:  CA
#   Is CN=Red Hat, OU=Red Hat, O=Red Hat, L=Toronto, ST=ON, C=CA correct?
#    [no]:  yes
#
#   Enter key password for <selfsigned>
#          (RETURN if same as keystore password): supersecret
#   Re-enter new password: supersecret
#   secret/eap-app-secret
#   serviceaccount "eap-service-account" created
# Create EAP Application                                                                                                                                                 [63/6518]
# oc new-app --template=eap64-https-s2i -p HTTPS_NAME=selfsigned,HTTPS_PASSWORD=supersecret
#
# --> Deploying template eap64-https-s2i in project openshift for "eap64-https-s2i"
#      With parameters:
#       APPLICATION_NAME=eap-app
#       HOSTNAME_HTTP=
#       HOSTNAME_HTTPS=
#       SOURCE_REPOSITORY_URL=https://github.com/jboss-developer/jboss-eap-quickstarts
#       SOURCE_REPOSITORY_REF=6.4.x
#       CONTEXT_DIR=kitchensink
#       HORNETQ_QUEUES=
#       HORNETQ_TOPICS=
#       HTTPS_SECRET=eap-app-secret
#       HTTPS_KEYSTORE=keystore.jks
#       HTTPS_NAME=selfsigned
#       HTTPS_PASSWORD=supersecret
#       HORNETQ_CLUSTER_PASSWORD=Itb7UbWE # generated
#       GITHUB_WEBHOOK_SECRET=41ReHmnA # generated
#       GENERIC_WEBHOOK_SECRET=hqN1DU2C # generated
#       IMAGE_STREAM_NAMESPACE=openshift
#       JGROUPS_ENCRYPT_SECRET=eap-app-secret
#       JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks
#       JGROUPS_ENCRYPT_NAME=
#       JGROUPS_ENCRYPT_PASSWORD=
#       JGROUPS_CLUSTER_PASSWORD=OqFyILML # generated
# --> Creating resources with label app=eap-app ...
#     Service "eap-app" created
#     Service "secure-eap-app" created
#     Route "eap-app" created
#     Route "secure-eap-app" created
#     ImageStream "eap-app" created
#     BuildConfig "eap-app" created
#     DeploymentConfig "eap-app" created
# --> Success
#     Build scheduled for "eap-app" - use the logs command to track its progress.
#     Run 'oc status' to view your app.

# 3. Open Broswer and Go to "https://secure-eap-app-test.${subdomain}"
~~~