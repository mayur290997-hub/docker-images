FROM oraclelinux

LABEL maintainer="digital_devops@oracle.com"

RUN groupadd -g 1000  devops && \
    useradd -d /home/devops -u 1000 -g devops -m -s /bin/bash devops && \
    echo "proxy=http://www-proxy.us.oracle.com:80/" >> /etc/yum.conf && \
    echo "http_proxy = https://www-proxy.us.oracle.com:80/" >> /etc/wgetrc && \
    yum install -y unzip tar curl procps hostname vim wget netcat which 
	
ENV TZ=Asia/Calcutta  										\
    http_proxy=https://www-proxy.us.oracle.com:80  			\
    https_proxy=https://www-proxy.us.oracle.com:80			\
	HOSTNAME=obdxjenkins.in.oracle.com              		\
    USR_HOME=/home/devops                           		\
    JAVA_HOME=/home/devops/jdk1.8.0_241             		\
	PATH=$JAVA_HOME/bin:$PATH   							\
    JENKINS_HOME=/scratch/app/product/jenkins    			\
	REF=/scratch/app/product/jenkins/ref					\
	JENKINS_VERSION=2.237 									\
    SW_BASE_DIR=/scratch/app/product  						\
	JENKINS_UC=https://updates.jenkins.io					\
	JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental	\
	JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals

USER root
 
RUN mkdir -p ${REF}/init.groovy.d && \	
    chown -R devops:devops /scratch/
	

# Perform the following actions as the devops user

USER devops

ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

RUN cd ${USR_HOME}  && \
    wget --no-proxy http://whf00jeo:8080/software/JAVA/jdk1.8.0_241.zip && \
    unzip -oq jdk1.8.0_241.zip &&\
    rm -rf jdk1.8.0_241.zip && \
    chmod -R 755 ${JAVA_HOME}  && \
	curl -fsSL ${JENKINS_URL} -o ${SW_BASE_DIR}/jenkins.war 


USER root

RUN chown -R devops:devops /scratch/ &&\
    chmod -R 755 /scratch/

USER devops

COPY --chown=devops:devops proxy.xml ${JENKINS_HOME}/proxy.xml
COPY --chown=devops:devops entrypoint.sh ${SW_BASE_DIR}/entrypoint.sh

ENTRYPOINT ["sh","/scratch/app/product/entrypoint.sh"]

EXPOSE 8080

COPY --chown=devops:devops plugins.sh ${SW_BASE_DIR}/plugins.sh
COPY --chown=devops:devops plugins.txt ${SW_BASE_DIR}/plugins.txt
COPY --chown=devops:devops credentials.xml ${JENKINS_HOME}/credentials.xml
COPY --chown=devops:devops config.xml ${JENKINS_HOME}/config.xml

RUN ${SW_BASE_DIR}/plugins.sh ${SW_BASE_DIR}/plugins.txt
RUN echo 2.0 > ${JENKINS_HOME}/ref/jenkins.install.UpgradeWizard.state