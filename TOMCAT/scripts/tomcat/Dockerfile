FROM oraclelinux:7-slim

LABEL maintainer="digital_devops@oracle.com"

RUN groupadd -g 1000  devops && \
    useradd -d /home/devops -u 1000 -g devops -m -s /bin/bash devops && \
    echo "http_proxy = http://www-proxy.us.oracle.com:80/" >> /etc/wgetrc && \
    echo "https_proxy = http://www-proxy.us.oracle.com:80/" >> /etc/wgetrc && \
    echo "proxy=http://www-proxy.us.oracle.com:80/" >> /etc/yum.conf && \ 
        yum install -y \
                unzip \
                tar \
				curl \
				procps \
				hostname \
				vim \
				wget \
				netcat 
	
ENV HOSTNAME=obdxtomcat.in.oracle.com               \
    USR_HOME=/home/devops                           \
    JAVA_HOME=/home/devops/jdk1.8.0_241              \
    CATALINA_HOME=/scratch/app/product/apache-tomcat-9.0.35        \
	SW_BASE_DIR=/scratch/app/product  \
    PATH=$CATALINA_HOME/bin:$PATH                    \
	PATH=$JAVA_HOME/bin:$PATH	\
	FLYWAY_BASEDIR=/scratch/obdx/flywayinstalltion \
	POLICY_BASEDIR=/scratch/obdx/policy \
	ANT_HOME=/scratch/app/product/apache-ant-1.10.9
 
# Perform the following actions as the oracle user
USER root

RUN mkdir -p ${SW_BASE_DIR} && \
    chown -R devops:devops ${SW_BASE_DIR} &&\
	mkdir -p ${FLYWAY_BASEDIR} &&\
	chown -R devops:devops ${FLYWAY_BASEDIR} &&\
	mkdir -p ${POLICY_BASEDIR} &&\
	chown -R devops:devops ${POLICY_BASEDIR} &&\
    mkdir -p /scratch/obdx/ &&\
    chown -R devops:devops /scratch/obdx/ 

USER devops
    
RUN cd ${USR_HOME}  && \
    wget --no-proxy https://artifacthub.oraclecorp.com/fsgbubanking-gradle-dev-local/oracle/fsgbu/depot/jdk-8u241-linux-x64.tar.gz && \
	tar -xvf jdk-8u241-linux-x64.tar.gz && \
	rm -f jdk-8u241-linux-x64.tar.gz && \
    chmod -R 755 ${JAVA_HOME}  &&\
	cd ${SW_BASE_DIR}     && \
    wget --no-proxy  https://artifacthub.oraclecorp.com/fsgbubanking-gradle-dev-local/oracle/fsgbu/depot/apache-tomcat-9.0.35.tar.gz && \
	tar -xvf apache-tomcat-9.0.35.tar.gz && \
	chmod u+x ${SW_BASE_DIR}/*  && \
	rm -f apache-tomcat-9.0.35.tar.gz && \
	cd ${CATALINA_HOME}/lib && \
    wget --no-proxy https://artifacthub.oraclecorp.com/fsgbubanking-gradle-dev-local/oracle/fsgbu/depot/HikariCP-3.3.1.jar && \
    wget --no-proxy https://artifacthub.oraclecorp.com/fsgbubanking-gradle-dev-local/oracle/fsgbu/depot/slf4j-api-1.7.26.jar && \
    wget --no-proxy https://artifacthub.oraclecorp.com/fsgbubanking-gradle-dev-local/oracle/fsgbu/depot/slf4j-simple-1.7.26.jar && \
    wget --no-proxy https://artifacthub.oraclecorp.com/fsgbubanking-gradle-dev-local/oracle/fsgbu/depot/ojdbc7.jar && \
    cd ${FLYWAY_BASEDIR}	&&\
	wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/6.5.1/flyway-commandline-6.5.1-linux-x64.tar.gz | tar xvz && mv `pwd`/flyway-6.5.1/* /scratch/obdx/flywayinstalltion/ &&\
	rm -rf flyway-commandline-6.5.1-linux-x64.tar.gz &&\
	cd ${SW_BASE_DIR} &&\
    wget https://mirrors.estointernet.in/apache/ant/binaries/apache-ant-1.10.9-bin.tar.gz &&\
    tar xzf apache-ant-1.10.9-bin.tar.gz &&\
    rm -rf apache-ant-1.10.9-bin.tar.gz &&\
    wget -O ${SW_BASE_DIR}/apache-ant-1.10.9/lib/jsch-0.1.55.jar https://sourceforge.net/projects/jsch/files/jsch.jar/0.1.55/jsch-0.1.55.jar &&\
    mkdir -p ${SW_BASE_DIR}/apache-ant-1.10.9/lib/weblogic &&\
    wget -O ${SW_BASE_DIR}/apache-ant-1.10.9/lib/weblogic/wlfullclient.jar --no-proxy http://whf00jeo.in.oracle.com:8080/software/ANT_JAR/wlfullclient.jar &&\
    wget -O ${SW_BASE_DIR}/apache-ant-1.10.9/lib/weblogic/com.bea.core.descriptor.wl_1.4.0.0.jar --no-proxy http://whf00jeo.in.oracle.com:8080/software/ANT_JAR/com.bea.core.descriptor.wl_1.4.0.0.jar &&\
    wget -O ${SW_BASE_DIR}/apache-ant-1.10.9/lib/weblogic/weblogic.jar --no-proxy http://whf00jeo.in.oracle.com:8080/software/ANT_JAR/weblogic.jar &&\
    cd /scratch/obdx && \
    wget -O ${SW_BASE_DIR}/apache-ant-1.10.9/lib/ant-contrib-1.0b3.jar --no-proxy http://whf00jeo.in.oracle.com:8080/software/ANT_JAR/ant-contrib-1.0b3.jar &&\
    ${JAVA_HOME}/jre/bin/keytool -genkey -v -keystore authserver.keystore -alias authserver -storepass authserverpass -keypass authserverpass -dname "CN=Developer, OU=Department, O=Company, L=City, ST=State, C=CA" &&\
    mkdir db_scripts &&\
    chown -R devops:devops *


COPY --chown=devops:devops lib_Added/* ${CATALINA_HOME}/lib/
COPY --chown=devops:devops tomcatConfig.sh ${CATALINA_HOME}/bin/
COPY --chown=devops:devops tomcatDeployWar.sh ${CATALINA_HOME}/bin/
COPY --chown=devops:devops digx.xml ${CATALINA_HOME}/conf/Catalina/localhost/
COPY --chown=devops:devops checkout/flyway /scratch/obdx/db_scripts/flyway
COPY --chown=devops:devops genericrest/seed /scratch/obdx/db_scripts/seed
COPY --chown=devops:devops flywayscripts /scratch/obdx/flywayscripts
COPY --chown=devops:devops digx /scratch/app/product/apache-tomcat-9.0.35/webapps/digx
COPY --chown=devops:devops build.xml /scratch/obdx/policy/
COPY --chown=devops:devops jars /scratch/obdx/policy/jars/

RUN sh -x ${CATALINA_HOME}/bin/tomcatConfig.sh && \
    sh -x ${CATALINA_HOME}/bin/tomcatDeployWar.sh &&\
	sh -x /scratch/obdx/flywayscripts/flyway.sh &&\
	$ANT_HOME/bin/ant -v -buildfile /scratch/obdx/policy/build.xml Feed_data_task_jar_run_it dashboard_seed_jar_run_it entitlement_jar_run_it

EXPOSE 8080
EXPOSE 8000

WORKDIR ${CATALINA_HOME}/bin
CMD ["catalina.sh", "run"]

