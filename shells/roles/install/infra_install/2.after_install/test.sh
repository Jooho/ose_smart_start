
. $CONFIG_PATH/ose_config.sh


awk '/identityProviders:/{printf $0; while(getline line<"ldap.yaml"){print line};next}1' test.yaml >test2.yaml
