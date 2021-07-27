#!/bin/bash
TC_VERSION=9.0.50
JAVA_VERSION=jdk8u292-b10
INSTALL_DIR=/usr/mware
INSTANCE_NAME=app1
INSTANCE_BASE_PATH=/usr/mware/tomcatApps/${INSTANCE_NAME}
INSTANCE_APPBASE_PATH=/usr/mware/tomcatAppDetails/${INSTANCE_NAME}
CATALINA_HOME=${INSTALL_DIR}/apache-tomcat-${TC_VERSION}

wget https://downloads.apache.org/tomcat/tomcat-9/v${TC_VERSION}/bin/apache-tomcat-${TC_VERSION}.tar.gz
wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u292-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u292b10.tar.gz

mkdir -p $INSTALL_DIR && cd $INSTALL_DIR
tar -xzf apache-tomcat-${TC_VERSION}.tar.gz
tar -xzf OpenJDK8U-jdk_x64_linux_hotspot_8u292b10.tar.gz

ln -s ${INSTALL_DIR}/${JAVA_VERSION} java

${CATALINA_HOME}/bin/makebase.sh  $INSTANCE_BASE_PATH

cd $INSTANCE_BASE_PATH 
cp ${CATALINA_HOME}/bin/* $INSTANCE_BASE_PATH/bin/
rm -f ${INSTANCE_BASE_PATH}/bin/*.bat
rm -fr ${INSTANCE_BASE_PATH}/lib && ln -s ${CATALINA_HOME}/lib 
rm -fr ${INSTANCE_BASE_PATH}/webapp

mkdir -p $INSTANCE_APPBASE_PATH/lib  $INSTANCE_APPBASE_PATH/webapps  $INSTANCE_APPBASE_PATH/xmlbase  $INSTANCE_APPBASE_PATH/work 

tee -a  ${INSTANCE_BASE_PATH}/bin/setenv.sh << EOF
JAVA_HOME=${INSTALL_DIR}/java
CATALINA_PID=$INSTANCE_BASE_PATH/logs/${INSTANCE_NAME}.pid
CATALINA_OPTS="-Xms128M -Xmx1024M -server"
JAVA_OPTS="-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
EOF









