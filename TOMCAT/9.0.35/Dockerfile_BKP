FROM oraclelinux

LABEL maintainer="rajesh.nawale@oracle.com"

ENV http_proxy=http://www-proxy-hqdc.us.oracle.com:80/
ENV https_proxy=https://www-proxy-hqdc.us.oracle.com:80/

RUN groupadd -g 1000  devops && \
    useradd -d /home/devops -u 1000 -g devops -m -s /bin/bash devops && \
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
    CATALINA_HOME=/scratch/app/product/tomcat        \
    PATH=$CATALINA_HOME/bin:$PATH
 
# Perform the following actions as the oracle user
USER devops
    
RUN mkdir -p ${CATALINA_HOME} && \
    chmod u+x ${CATALINA_HOME}/* && \
    cd ${USR_HOME}  && \
    wget --no-proxy http://whf00jeo:8080/software/JAVA/jdk1.8.0_241.zip && \
    unzip -oq jdk1.8.0_241.zip &&\
    rm -rf jdk1.8.0_241.zip && \
    chmod -R 755 ${JAVA_HOME}  && \
    cd ${CATALINA_HOME}     && \
    wget --no-proxy https://downloads.apache.org/tomcat/tomcat-9/v9.0.35/bin/apache-tomcat-9.0.35.tar.gz  && \
    tar xvf apache-tomcat-9.0.35.tar.gz  && \
    rm -rf apache-tomcat-9.0.35.tar.gz  
	
EXPOSE 8090
WORKDIR ${CATALINA_HOME}
CMD ["catalina.sh", "run"]