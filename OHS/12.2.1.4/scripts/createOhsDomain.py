#!/usr/bin/python
import os, sys
import time
import getopt
import re

# Get location of the properties file.
properties = ''
try:
   opts, args = getopt.getopt(sys.argv[1:],"p:h::",["properies="])
except getopt.GetoptError:
   print 'create_domain.py -p <path-to-properties-file>'
   sys.exit(2)
for opt, arg in opts:
   if opt == '-h':
      print 'create_domain.py -p <path-to-properties-file>'
      sys.exit()
   elif opt in ("-p", "--properties"):
      properties = arg
print 'properties=', properties

# Load the properties from the properties file.
from java.io import FileInputStream
 
propInputStream = FileInputStream(properties)
configProps = Properties()
configProps.load(propInputStream)

v_mwHome=configProps.get("MW_HOME")
v_jdkHome=configProps.get("JDK_HOME")
v_domainHome=configProps.get("DOMAIN_HOME")
v_domainName=configProps.get("DOMAIN_NAME")
v_NMUsername=configProps.get("NM_USERNAME")
v_NMPassword=configProps.get("NM_PASSWORD")
v_NMHome=configProps.get("NM_HOME")
v_NMHost=configProps.get("NM_LISTENADDRESS")
v_NMPort=configProps.get("NM_PORT")
v_OHSInstanceName=configProps.get("OHS_COMPONENT_NAME")
v_OHSAdminPort=configProps.get("OHSADMINPORT")
v_OHSHTTPPort=configProps.get("OHSHTTPPORT")
v_OHSHTTPSPort=configProps.get("OHSHTTPSPORT")
v_NMType=configProps.get("NM_TYPE")

# Display the variable values.
print 'MW_HOME=', v_mwHome
print 'JDK_HOME=', v_jdkHome
print 'DOMAIN_HOME=', v_domainHome
print 'DOMAIN_NAME=', v_domainName
print 'NM_USERNAME=', v_NMUsername
print 'NM_PASSWORD=', v_NMPassword
print 'NM_HOME=', v_NMHome
print 'NM_LISTENADDRESS=', v_NMHost
print 'NM_PORT=', v_NMPort
print 'OHS_COMPONENT_NAME=', v_OHSInstanceName
print 'OHSADMINPORT=', v_OHSAdminPort
print 'OHSHTTPPORT=', v_OHSHTTPPort
print 'OHSHTTPSPORT=', v_OHSHTTPSPort
print 'NM_TYPE=', v_NMType


readTemplate(v_mwHome +'/wlserver/common/templates/wls/base_standalone.jar')
addTemplate(v_mwHome +'/ohs/common/templates/wls/ohs_standalone_template.jar')

cd('/')
create(v_domainName, 'SecurityConfiguration')
cd('SecurityConfiguration/' + v_domainName)
set('NodeManagerUsername',v_NMUsername)
set('NodeManagerPasswordEncrypted',v_NMPassword)
setOption('NodeManagerType', 'PerDomainNodeManager')

cd('/')
create('ohs_machine', 'Machine')
cd('/Machines/ohs_machine')
create('ohs_machine', 'NodeManager')
cd('NodeManager/ohs_machine')

cd('/')
delete(v_OHSInstanceName,'SystemComponent')
create (v_OHSInstanceName,'SystemComponent')
cd('/OHS/'+v_OHSInstanceName)
#cmo.setComponentType('OHS')
#set('Machine', 'ohs_machine')

#cd('/OHS/ohs1')
cd('/OHS/'+v_OHSInstanceName)
cmo.setAdminHost(v_NMHost)
cmo.setAdminPort(v_OHSAdminPort)
cmo.setListenAddress(v_NMHost)
cmo.setListenPort(v_OHSHTTPPort)
cmo.setSSLListenPort(v_OHSHTTPSPort)

writeDomain(v_domainHome)
closeTemplate()
exit()
