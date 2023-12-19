FROM oraclelinux:7-slim

MAINTAINER Rajesh Nawale <rajesh.nawale@oracle.com>

RUN groupadd -g 1000  devops && \
    useradd -d /home/devops -u 1000 -g devops -m -s /bin/bash devops 

RUN mkdir -p /scratch/obdx 

RUN chmod -R 777 /scratch/obdx/ 


RUN echo "proxy=http://www-proxy.idc.oracle.com:80" >> /etc/yum.conf && \
    echo "http_proxy = http://www-proxy.idc.oracle.com:80" >> /etc/wgetrc && \
    yum -y install oracle-epel-release-el7 oracle-release-el7 && yum-config-manager --enable ol7_oracle_instantclient && yum-config-manager --enable oracle-epel-release-el7 && \
	yum -y install	vi oracle-instantclient19.3-basic curl python-pip procps hostname

ENV HTTP_PROXY "http://www-proxy.idc.oracle.com:80"
ENV	HTTPS_PROXY	"http://www-proxy.idc.oracle.com:80"


RUN python -m pip install cx_Oracle urwid==1.3.1


USER devops

ENV USR_HOME=/home/devops				\
	JAVA_HOME=/home/devops/jdk18		\
	ORACLE_HOME=/home/devops/Oracle/Middleware/Oracle_Home \
	SOFTWAREDIR=/home/devops/software       \
	FMW_JAR=fmw_12.2.1.4.0_infrastructure.jar \
    LD_LIBRARY_PATH=/usr/lib/oracle/19.3/client64/lib/:$LD_LIBRARY_PATH

RUN mkdir -p ${SOFTWAREDIR} &&\
	mkdir -p ${JAVA_HOME} 

COPY --chown=devops:devops ${FMW_JAR} ${SOFTWAREDIR}
COPY --chown=devops:devops jdk18 ${JAVA_HOME}
COPY --chown=devops:devops install.file oraInst.loc ${USR_HOME}/


RUN  $JAVA_HOME/bin/java -jar  ${SOFTWAREDIR}/${FMW_JAR} -silent -responseFile ${USR_HOME}/install.file -invPtrLoc ${USR_HOME}/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" 

