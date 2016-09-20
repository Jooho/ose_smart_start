CERT
---
These script generate certifiation according to situation.


##Generate Certificate For Request
This script generate csr/private key file to request for signing it by private certificate.

### Usage

	generate_certReq.sh <CertObj> <ENV|HOSTNAME>
	
	Example
	generate_certReq.sh api pnp  ==> api.pnp.cloudapps.ao.dcn
	generate_certReq.sh star pnp ==> *.pnp.cloudapps.ao.dcn
	generate_certReq.sh uniq sourcehub.ao.dcn ==> sourcehub.ao.dcn
	
	
===

##Generate SNI Certificate
This script generate SNI certificate. You need to update configuration variables in the script before executing it.

###Configuration Variables
	[req]
	distinguished_name = req_distinguished_name
	req_extensions = v3_req

	[req_distinguished_name]
	countryName = US
	countryName_default = US
	stateOrProvinceName = District of Columbia
	stateOrProvinceName_default = District of Columbia
	localityName = Washington
	localityName_default = Washington
	organizationName = Red Hat
	organizationName_default = Red Hat
	organizationalUnitName = PaaS Practice
	organizationalUnitName_default = PaaS Practice
	commonName = ${COMMONNAME}
	commonName_default = ${COMMONNAME}
	commonName_max  = 64

	emailAddress = ose_pilot@redhat.com
	emailAddress_default = ose_pilot@redhat.com

	[req_attributes]
	challengePasssword  = 'RedH@tOs3'

	[ v3_req ]
	# Extensions to add to a certificate request
	basicConstraints = CA:FALSE
	keyUsage = nonRepudiation, digitalSignature, keyEncipherment
	subjectAltName = @alt_names

	[alt_names]
	DNS.1 = ${COMMONNAME}
	DNS.2 = master1.example.com
	DNS.3 = master2.example.com
	DNS.4 = master3.example.com
	
	
### Usage

	generate_certReq.sh <CertObj> <ENV|HOSTNAME>
	
	Example
	generate_certReq.sh api pnp  ==> api.pnp.cloudapps.ao.dcn
	generate_certReq.sh star pnp ==> *.pnp.cloudapps.ao.dcn
	generate_certReq.sh uniq sourcehub.ao.dcn ==> sourcehub.ao.dcn


===


## Generate Self Signed Certificate with OC command
This script generate self signed certificate using `oadm ca create-server-cert`
### Usage
	generate_selfSignedCert.sh <CertPATH> <HOSTNAME>
	
	Example
	generate_selfSignedCert.sh /etc/origin/master test.pnp.cloudapps.ao.dcn

===

##  Generate Self Signed Certificate without OC command
This script generate self signed certificate from the scratch. `ca.serial.txt` file should has ramdom number(two digit : 45)


### Usage
	
	 generate_selfSignedCert_without_oc.sh <HOST_NAME> <SIGNER_KEY> <SIGNER_CERT> <SIGNER_SERIAL>
	 
	Example
	generate_selfSignedCert_without_oc.sh helloworld.cloudapps.example.com  /etc/origin/master/ca.key /etc/origin/master/ca.crt /etc/origin/master/ca.serial.txt
	generate_selfSignedCert_without_oc.sh helloworld.cloudapps.example.com  ./ca.key ./ca.crt ./ca.serial.txt