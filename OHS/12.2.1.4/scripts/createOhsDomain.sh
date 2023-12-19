#!/bin/bash
# Copyright (c) 2017-2019 Oracle and/or its affiliates. All rights reserved.
#
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#
#*************************************************************************
#  This script is used to create a standalone OHS domain and start NodeManager, OHS instance.
#  This script sets the following variables:
#
#  WL_HOME    - The Weblogic home directory
#  NODEMGR_HOME  - Absolute path to Nodemanager directory under the configured domain home
#  DOMAIN_HOME - Absolute path to configured domain home
#  JAVA_HOME- Absolute path to jre inside the oracle home directory
#*************************************************************************
########### SIGTERM handler ############

source  ${SCRIPTS_DIR}/ohsDomain.properties

echo "MW_HOME=${MW_HOME:?"Please set MW_HOME"}"
echo "ORACLE_HOME=${ORACLE_HOME:?"Please set ORACLE_HOME"}"
echo "DOMAIN_NAME=${DOMAIN_NAME:?"Please set DOMAIN_NAME"}"
echo "OHS_COMPONENT_NAME=${OHS_COMPONENT_NAME:?"Please set OHS_COMPONENT_NAME"}"

export MW_HOME ORACLE_HOME DOMAIN_NAME OHS_COMPONENT_NAME


#Set WL_HOME, WLST_HOME, DOMAIN_HOME and NODEMGR_HOME
WL_HOME=${ORACLE_HOME}/wlserver
WLST_HOME=${ORACLE_HOME}/oracle_common/common/bin
echo "WLST_HOME=${WLST_HOME}"

DOMAIN_HOME=${ORACLE_HOME}/user_projects/domains/${DOMAIN_NAME}
export DOMAIN_HOME
echo "DOMAIN_HOME=${DOMAIN_HOME}"

NODEMGR_HOME=${DOMAIN_HOME}/nodemanager
export NODEMGR_HOME

echo "PATH=${PATH}"
PATH=$PATH:/usr/java/default/bin:${ORACLE_HOME}/oracle_common/common/bin
export PATH
echo "PATH=${PATH}"

#  Set JAVA_OPTIONS and JAVA_HOME for node manager
JAVA_OPTIONS="${JAVA_OPTIONS} -Dweblogic.RootDirectory=${DOMAIN_HOME}"
export JAVA_OPTIONS

JAVA_HOME=${ORACLE_HOME}/oracle_common/jdk/jre
export JAVA_HOME
 
PROPERTIES_FILE=${SCRIPT_HOME}/ohsDomain.properties
export PROPERTIES_FILE

if [ ! -e "$PROPERTIES_FILE" ]; then
   echo "A properties file with the username and password needs to be supplied."
   exit
fi

# If nodemanager$$.log does not exists,this is the first time configuring the NM 
# generate the NM password 

if [ !  -f ${DOMAIN_HOME}/nodemanager/nodemanager$$.log ]; then

# Get Username
NM_USER=`awk '{print $1}' $PROPERTIES_FILE | grep username | cut -d "=" -f2`
if [ -z "$NM_USER" ]; then
   echo "The Node Manager username is blank. It must be set in the properties file."
   exit
fi

# Get Password
NM_PASSWORD=`awk '{print $1}' $PROPERTIES_FILE | grep password | cut -d "=" -f2`
if [ -z "$NM_PASSWORD" ]; then
   echo "The Node Manager password is blank. It must be set in the properties file."
   exit
fi
    
wlst.sh -skipWLSModuleScanning /home/devops/scripts/createOhsDomain.py -p $PROPERTIES_FILE
#wlst.sh -skipWLSModuleScanning -loadProperties $PROPERTIES_FILE /home/devops/scripts/createOhsDomain.py -p $PROPERTIES_FILE
# Set the NM username and password in the properties file
echo "username=$NM_USER" >> ${DOMAIN_HOME}/config/nodemanager/nm_password.properties
echo "password=$NM_PASSWORD" >> ${DOMAIN_HOME}/config/nodemanager/nm_password.properties

fi

echo "Starting replace task"
sed -i 's/127.0.0.1/obdxohs.in.oracle.com/g' ${DOMAIN_HOME}/config/fmwconfig/components/OHS/instances/ohs1/admin.conf
sed -i 's/localhost/obdxohs.in.oracle.com/g' ${DOMAIN_HOME}/config/fmwconfig/components/OHS/instances/ohs1/admin.conf
sed -i 's/127.0.0.1/obdxohs.in.oracle.com/g' ${DOMAIN_HOME}/config/fmwconfig/components/OHS/ohs1/admin.conf
sed -i 's/localhost/obdxohs.in.oracle.com/g' ${DOMAIN_HOME}/config/fmwconfig/components/OHS/ohs1/admin.conf
sed -i 's/localhost/obdxohs.in.oracle.com/g' ${DOMAIN_HOME}/nodemanager/nodemanager.properties
sed -i "s/SSLEngine on/SSLEngine off/g" ${DOMAIN_HOME}/config/fmwconfig/components/OHS/instances/ohs1/ssl.conf
sed -i "s/SSLEngine on/SSLEngine off/g" ${DOMAIN_HOME}/config/fmwconfig/components/OHS/instances/ohs1/admin.conf
sed -i "s/SSLEngine on/SSLEngine off/g" ${DOMAIN_HOME}/config/fmwconfig/components/OHS/ohs1/admin.conf
sed -i "s/SSLEngine on/SSLEngine off/g" ${DOMAIN_HOME}/config/fmwconfig/components/OHS/ohs1/ssl.conf
sed -i 's/localhost/obdxohs.in.oracle.com/g' ${DOMAIN_HOME}/config/config.xml
echo "Replace task completed"

