#!/bin/bash
CATALINA_HOME=/scratch/app/product/apache-tomcat-9.0.35

#<TOMCAT_DIR>/bin/catalina.sh
sed -e '/Dorg.apache.catalina.security.SecurityListener.UMASK/ s/^#*/#/' -i $CATALINA_HOME/bin/catalina.sh
sed -e '/Dorg.apache.catalina.security.SecurityListener.UMASK/a JAVA_OPTS="$JAVA_OPTS -Dfcat.jvm.id=1"' -i $CATALINA_HOME/bin/catalina.sh

#<TOMCAT_DIR>/webapps/manager/META-INF/context.xml comment below line
sed -e '/org.apache.catalina.valves.RemoteAddrValve/ s/<*/<!--/' -i $CATALINA_HOME/webapps/manager/META-INF/context.xml
sed -e '/127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1/ s/>/-->/' -i $CATALINA_HOME/webapps/manager/META-INF/context.xml

#<TOMCAT_DIR>/conf/context.xml increasing cacheMaxSize
sed -i "s#</Context>##g" $CATALINA_HOME/conf/context.xml
echo '<Resources cachingAllowed="true" cacheMaxSize="100000" />' >> $CATALINA_HOME/conf/context.xml
echo '<Loader delegate="true"/>' >> $CATALINA_HOME/conf/context.xml
echo '</Context>' >> $CATALINA_HOME/conf/context.xml

#<TOMCAT_DIR>/conf/tomcat-users.xml add below line
sed -e 's|</tomcat-users>||' -i $CATALINA_HOME/conf/tomcat-users.xml
echo '<role rolename="manager-gui"/>' >> $CATALINA_HOME/conf/tomcat-users.xml
echo '<user username="admin" password="admin" roles="manager-gui"/>' >> $CATALINA_HOME/conf/tomcat-users.xml
echo "</tomcat-users>" >> $CATALINA_HOME/conf/tomcat-users.xml

#<TOMCAT_DIR>/conf/server.xml add below line
sed -e 's|</Host>||' -i $CATALINA_HOME/conf/server.xml
sed -e 's|</Engine>||' -i $CATALINA_HOME/conf/server.xml
sed -e 's|</Service>||' -i $CATALINA_HOME/conf/server.xml
sed -e 's|</Server>||' -i $CATALINA_HOME/conf/server.xml
echo '<Context docBase="'"$CATALINA_HOME"'/logs" path="/logs"/>' >> $CATALINA_HOME/conf/server.xml
echo '</Host>' >> $CATALINA_HOME/conf/server.xml
echo '</Engine>' >> $CATALINA_HOME/conf/server.xml
echo '</Service>' >> $CATALINA_HOME/conf/server.xml
echo '</Server>' >> $CATALINA_HOME/conf/server.xml 			

#<TOMCAT_DIR>/conf/catalina.properties
#add the following line – org.apache.tomcat.util.digester.PROPERTY_SOURCE=com.ofss.digx.utils.tomcat.propertysource.DigxPropertySource
echo 'org.apache.tomcat.util.digester.PROPERTY_SOURCE=com.ofss.digx.utils.tomcat.propertysource.DigxPropertySource' >> $CATALINA_HOME/conf/catalina.properties

#Create a file resources.properties in <TOMCAT_DIR>/lib directory
# copy ojdbc7.jar and com.ofss.digx.utils.tomcat.jar at <TOMCAT_DIR>/lib folder

#enable debug port of tomcat
sed -e 's|exec "$PRGDIR"/"$EXECUTABLE" start "$@"||' -i $CATALINA_HOME/bin/startup.sh
echo 'export JPDA_ADDRESS=8000' >> $CATALINA_HOME/bin/startup.sh
echo 'export JPDA_TRANSPORT=dt_socket' >> $CATALINA_HOME/bin/startup.sh
echo 'exec "$PRGDIR"/"$EXECUTABLE" jpda start "$@"' >> $CATALINA_HOME/bin/startup.sh
