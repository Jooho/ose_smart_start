#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.14
# Purpose: This script help update ca trust for Root CA on all VMs.
#          Without the certs, it can not establish connection with another application which use PCA cert.     
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160714   jooho   Create
#
#
#

echo "Creating /etc/pki/ca-trust/source/anchors/USCOURTSPrivateSSLCA.pem"
sudo cat << EOF > /etc/pki/ca-trust/source/anchors/USCOURTSPrivateSSLCA.pem
-----BEGIN CERTIFICATE-----
MIIEhTCCA22gAwIBAgIQapotYhUnjdydAyWL04B05DANBgkqhkiG9w0BAQsFADB1
MQswCQYDVQQGEwJVUzE6MDgGA1UEChMxQWRtaW5pc3RyYXRpdmUgT2ZmaWNlIG9m
IHRoZSBVbml0ZWQgU3RhdGVzIENvdXJ0czEOMAwGA1UECxMFQU9VU0MxGjAYBgNV
BAMTEVVTIENPVVJUUyBST09UIENBMB4XDTE1MDQxNjAwMDAwMFoXDTI1MDQxMzIz
NTk1OVowfDELMAkGA1UEBhMCVVMxOjA4BgNVBAoTMUFkbWluaXN0cmF0aXZlIE9m
ZmljZSBvZiB0aGUgVW5pdGVkIFN0YXRlcyBDb3VydHMxDjAMBgNVBAsTBUFPVVND
MSEwHwYDVQQDExhVUyBDT1VSVFMgUHJpdmF0ZSBTU0wgQ0EwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQCuNBNwVW+oW66mmj234eSjxsxX9+zcPzxjGYoA
DWpH19CDc9D8YsIqNCdWObUuRpD7qBYmY3frIdxsmAbsuc5KQvk9aB9l/UiM6yQ5
jBcutp5kyicAXsFF1qiAzlGTFxW7KG+/DV5MexcegawQpti9f3WLxpAJAVeTBJwG
l2FK5m4rmz5qL5d6KxvPrIMnv2BHtjbiqY0yOQCFil6qbIwbaeWDANvMUhR0h7sD
O0PkTepO+gTPpIajy9AlHNM0yoAbNVR7kJmzDCjd6Gu9b5IkqcjtFngb8fQv3hEi
jDGpKl3O6FGCannlGKnadSAF1cLiMyWxqkMB3hGEv+tV1WF1AgMBAAGjggEIMIIB
BDASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBBjApBgNVHREEIjAg
pB4wHDEaMBgGA1UEAxMRU3ltYW50ZWNQS0ktMi0xMDYwHQYDVR0OBBYEFAJjFr0Z
w6j6WdNf/bE1Ww/dhdWhMB8GA1UdIwQYMBaAFOSFjmj4TZRmMrCiHLE9lHopqsuC
MHMGA1UdHwRsMGowaKBmoGSGYmh0dHA6Ly9wa2ktY3JsLnN5bWF1dGguY29tL29m
ZmxpbmVjYS9BZG1pbmlzdHJhdGl2ZU9mZmljZW9mdGhlVW5pdGVkU3RhdGVzQ291
cnRzVVNDT1VSVFNST09UQ0EuY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQAWk3kydNjI
IFOMIzQYw1+5Wnb5Am9GaxFumdmiHVsxjdqDlrpBovwqFbxDtuDhT3VE8lYUhLrt
kQG9CoR9E7i7PhpDJK9BSFwgQkXEv5UUYpXuHlnvBxtAuqaWVUKylubJU8d9gssb
Cp0uqihoOOh12ehJaAS9f54C0oObgLty0B2gWS0vVqtxM57yIWINB04XDUUcBu6y
03QvPhZ/uSNkS90fz4n/IhkeosYptS0SBDZnuEEc+gxPLGZB7DOF3nVq60eoTdFU
HQCZROJjBxu/eL0fQN0vD+QhtyCnlngQ3rZRCVzJNNWR3jBbfWJg7ginl/5Wxdy8
N/WaXbtpQNpn
-----END CERTIFICATE-----
EOF

echo "Creating /etc/pki/ca-trust/source/anchors/USCOURTSROOTCA.pem"
sudo cat << EOF > /etc/pki/ca-trust/source/anchors/USCOURTSROOTCA.pem
-----BEGIN CERTIFICATE-----
MIID4jCCAsqgAwIBAgIQMHzlPHU3YE2CV9k+QZFdajANBgkqhkiG9w0BAQsFADB1
MQswCQYDVQQGEwJVUzE6MDgGA1UEChMxQWRtaW5pc3RyYXRpdmUgT2ZmaWNlIG9m
IHRoZSBVbml0ZWQgU3RhdGVzIENvdXJ0czEOMAwGA1UECxMFQU9VU0MxGjAYBgNV
BAMTEVVTIENPVVJUUyBST09UIENBMB4XDTE1MDQxNDAwMDAwMFoXDTM1MDQxMzIz
NTk1OVowdTELMAkGA1UEBhMCVVMxOjA4BgNVBAoTMUFkbWluaXN0cmF0aXZlIE9m
ZmljZSBvZiB0aGUgVW5pdGVkIFN0YXRlcyBDb3VydHMxDjAMBgNVBAsTBUFPVVND
MRowGAYDVQQDExFVUyBDT1VSVFMgUk9PVCBDQTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBALMIPHs/vaUPfXTifGxY2UrGMMIB2HCDXd2nyUBBjQdZYoTj
Nac2HmNzkqj+iyKbdinQoyhCcb6PXWgrVYixEPld70SLcOPvVlE/ss7lUjqxIl+g
twhZd3yL8R2tDXuxsY6vNxipnxCebgUyxIhOgqwMU1NUScGtvvlKthCcNbsGjqzF
UYca10N8GPhHNgiaf4GUyWCpl92dUIgNLcC2ug8cfAhLWuZ/Gc3oY/29pYKT5XiN
hjgwIxzUfcU3h30dvh9IS4pqa+tdc2/3Wg3OuxrzzFBzBx7YzhFWfTI7boJNLgvt
SRLT+oWPXXlTL5OrT91u1dbKAsavJm5oNiaEqckCAwEAAaNuMGwwEgYDVR0TAQH/
BAgwBgEB/wIBATAOBgNVHQ8BAf8EBAMCAQYwJwYDVR0RBCAwHqQcMBoxGDAWBgNV
BAMTD01QS0ktMjA0OC0xLTE3OTAdBgNVHQ4EFgQU5IWOaPhNlGYysKIcsT2Ueimq
y4IwDQYJKoZIhvcNAQELBQADggEBAK64B7DkW8KWcW8ZdccR1p87yW+6iTGJ8Kro
L+lbY8sSFfY49ov0/m5A1B/nvKxuPHfFmHlDMDDKWn4kaZum6kpZi9S4pfMtCeu/
iONf9nzo3xrY5XC4Ks3OG09WRiJL+fL4YgzBABnPo+1oEvIksDWjalwGCzVZpual
ve2MsCIpaubJf+fzAbVB1BhxIJS80Q7+SIhMj51QXsIFeXjKQ9FqMeTsgczx93pu
cI1Bb/6UxkCrEXVbCYeEFaHe+JVn/NImjAj9qohAHd+jOfjMv62mcMT6cmKa4Kmp
rxushwL6/S5kyjHUnEQumavNjKkV3L+GhA1LBAR1VYSUDYtUUHg=
-----END CERTIFICATE-----
EOF

echo "sudo update-ca-trust"
sudo update-ca-trust
echo "sudo systemctl restart docker"
sudo systemctl restart docker



## Another way
#wget http://www.ssl.ao.dcn/US_COURTS_ROOT_CA.crt
#openssl x509 -inform DER -in US_COURTS_ROOT_CA.crt -outform PEM -out /etc/pki/ca-trust/source/anchors/US_COURTS_ROOT_CA.pem
#wget http://www.ssl.ao.dcn/US_COURTS_Private_SSL_CA.crt
#openssl x509 -inform DER -in US_COURTS_Private_SSL_CA.crt -outform PEM -out /etc/pki/ca-trust/source/anchors/US_COURTS_Private_SSL_CA.pem

