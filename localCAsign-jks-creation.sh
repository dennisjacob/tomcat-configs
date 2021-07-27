#!/bin/bash
instance=app1
echo "Creating CA key and certs"
openssl genrsa -out appserver-ca-root.key
openssl req -new -key appserver-ca-root.key -out appserver-ca-root.csr -subj "/CN=app-server-ca-root"
openssl x509 -req -in appserver-ca-root.csr -signkey appserver-ca-root.key -out appserver-ca-root.crt
openssl x509 -in appserver-ca-root.crt -subject -issuer -dates -noout

echo "Creating ${instance} key and cert"
openssl genrsa -out ${instance}.key
openssl req -new -key ${instance}.key -out ${instance}.csr -subj "/CN=${instance}.local"
openssl x509 -req -in ${instance}.csr -CA appserver-ca-root.crt -CAkey appserver-ca-root.key -out ${instance}.crt -CAcreateserial -CAserial serial
openssl x509 -in ${instance}.crt -noout -subject -dates -issuer

echo "Converting the certs in pem to jks"

cat ${instance}.key ${instance}.crt >${instance}.pem
openssl pkcs12 -export -out ${instance}.p12 -in ${instance}.pem -password pass:admin123
keytool -importkeystore -srckeystore ${instance}.p12 -destkeystore ${instance}.jks -destalias ${instance}-alias -srcstoretype pkcs12 -deststorepass admin123  -srcstorepass admin123 -srcalias 1
echo "yes" | keytool -importcert -alias ca-cert -file appserver-ca-root.crt -keystore ${instance}.jks -storepass admin123




