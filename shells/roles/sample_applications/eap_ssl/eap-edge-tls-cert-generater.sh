# edge
## Create jks file
#keytool -genkey -keyalg RSA -alias selfsigned -keystore keystore.jks -storepass supersecret -validity 360 -keysize 2048

## Create pkcs12
keytool -importkeystore -srckeystore keystore.jks  -destkeystore keystore.p12 -srcstoretype jks -deststoretype pkcs12

## Get private key from pkcs12
openssl pkcs12 -in keystore.p12 -nodes -password pass:supersecret

