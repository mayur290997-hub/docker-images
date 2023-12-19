FROM oraclelinux:7-slim

MAINTAINER rajesh.nawale@oracle.com

RUN groupadd -g 1000  devops && \
    useradd -d /home/devops -u 1000 -g devops -m -s /bin/bash devops && \
	mkdir -p /scratch/obdx && \
    chmod -R 777 /scratch/obdx  && \
	mkdir -p /scratch/ohs && \
    chmod -R 777 /scratch/ohs  && \
    echo "proxy=http://www-proxy.idc.oracle.com:80" >> /etc/yum.conf && \
    echo "http_proxy = http://www-proxy.idc.oracle.com:80" >> /etc/wgetrc && \
    yum -y install vi curl procps hostname libaio libmcrypt-devel vim wget unzip 

ENV HOSTNAME=obdxohs.in.oracle.com 				\
    USR_HOME=/home/devops             \
    JAVA_HOME=/home/devops/jdk1.8.0_241              \
    SCRIPTS_DIR=/home/devops/scripts				\
    SOFTWAREDIR=/home/devops/software            \
    ORACLE_HOME=/home/devops/Oracle/Middleware/Oracle_Home		
 

# Perform the following actions as the oracle user
USER devops

# Unzip software
RUN mkdir -p ${ORACLE_HOME} && \
    mkdir -p ${SCRIPTS_DIR}
	
COPY --chown=devops:devops scripts/* ${SCRIPTS_DIR}/ 

RUN mkdir -p ${SOFTWAREDIR} && \
	chmod u+x ${SCRIPTS_DIR}/* && \
	cd ${USR_HOME}  && \
	wget --no-proxy http://whf00jeo:8080/software/JAVA/jdk1.8.0_241.zip && \
	unzip -oq jdk1.8.0_241.zip &&\
	rm -rf jdk1.8.0_241.zip && \
	chmod -R 755 ${JAVA_HOME}  && \
	cd ${SOFTWAREDIR}		&& \
	wget --no-proxy http://whf00jeo:8080/software/OHS/fmw_12.2.1.4.0_ohs_linux64.bin.zip && \
	unzip -oq fmw_12.2.1.4.0_ohs_linux64.bin.zip && \
	chmod -R 755 fmw_12.2.1.4.0_ohs_linux64.bin && \
	${SOFTWAREDIR}/fmw_12.2.1.4.0_ohs_linux64.bin -silent -responseFile ${SOFTWAREDIR}/install.file -invPtrLoc ${SOFTWAREDIR}/oraInst.loc ORACLE_HOME=${ORACLE_HOME} && \
	sh ${SCRIPTS_DIR}/createOhsDomain.sh $$ \
	rm -rf fmw_12.2.1.4.0_ohs_linux64.bin.zip && \
	rm -rf fmw_12.2.1.4.0_ohs_linux64.bin
