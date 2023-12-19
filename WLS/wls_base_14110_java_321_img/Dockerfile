FROM container-registry.oracle.com/os/oraclelinux:8-slim

MAINTAINER DevOps <digital_devops_in_grp@oracle.com>

RUN groupadd -g 1000  devops && \
    useradd -d /home/devops -u 1000 -g devops -m -s /bin/bash devops && \
    mkdir -p /scratch/obdx && \
    chmod -R 777 /scratch/obdx/ &&\
    chown -R devops:devops /scratch/obdx  && \
    chmod -R 777 /scratch && \
    chmod -R 777 /tmp &&\
    echo "proxy=http://www-proxy.us.oracle.com:80/" >> /etc/yum.conf && \
    echo "http_proxy=http://www-proxy.us.oracle.com:80/" >> /etc/wgetrc && \
    echo "https_proxy=http://www-proxy.us.oracle.com:80/" >> /etc/wgetrc && \
    export http_proxy="http://www-proxy.us.oracle.com:80/" &&\
    export https_proxy="http://www-proxy.us.oracle.com:80/" &&\
    microdnf install -y python38 python38-devel python38-libs python38-pip python38-setuptools dnf yum && \
    microdnf install -y procps curl hostname vi vim wget zip unzip bzip2 nc net-tools tar && \
    microdnf clean all  && \
    microdnf install -y jq  && \ 
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/oracle-instantclient19.10-basic-19.10.0.0.0-1.x86_64.rpm && \
    dnf install -y oracle-instantclient19.10-basic-19.10.0.0.0-1.x86_64.rpm && \
    rm -v oracle-instantclient19.10-basic-19.10.0.0.0-1.x86_64.rpm && \
    python3.8 -m pip install cx_Oracle==8.1.0 urwid==2.1.2 wget requests 

USER devops

ENV USR_HOME=/home/devops               \
    JAVA_HOME=/scratch/app/java         \
    ORACLE_HOME=/scratch/app/product/Oracle/Middleware/Oracle_Home \
    SOFTWAREDIR=/scratch/app      \
    FLYWAY_HOME=/scratch/app/flyway \
    FMW_JAR=fmw_14.1.1.0.0_wls_lite_generic.jar \
    LD_LIBRARY_PATH=/usr/lib/oracle/19.10/client64/lib/:$LD_LIBRARY_PATH

RUN mkdir -p ${SOFTWAREDIR} &&\
    chmod 777 ${SOFTWAREDIR &&\
    mkdir -p ${JAVA_HOME} &&\
    mkdir -p  ${FLYWAY_HOME} &&\
    cd ${SOFTWAREDIR} &&\
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/JAVA/jdk-8u321-linux-x64.tar.gz &&\
    tar -xvf jdk-8u321-linux-x64.tar.gz &&\
    mv -v jdk1.8.0_321/*  ${JAVA_HOME} &&\
    rm -rvf jdk1.8.0_321 &&\
    chmod -R 755 ${JAVA_HOME} && \
    rm -rfv jdk-8u321-linux-x64.tar.gz &&\
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/FLYWAY/7.9.2/flyway-commandline-7.9.2-linux-x64.tar.gz &&\
    tar -xvf flyway-commandline-7.9.2-linux-x64.tar.gz &&\
    mv -v flyway-7.9.2/*   ${FLYWAY_HOME}  &&\
    rm -r flyway-7.9.2 && \
    chmod -R 755 ${FLYWAY_HOME} && \
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/${FMW_JAR} &&\
    chmod 755 ${SOFTWAREDIR}/${FMW_JAR} && \
    cd ${USR_HOME} &&\ 
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/install.file &&\ 
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/oraInst.loc 

RUN $JAVA_HOME/bin/java -jar  ${SOFTWAREDIR}/${FMW_JAR} -silent -responseFile ${USR_HOME}/install.file -invPtrLoc ${USR_HOME}/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server"  && \
rm -rfv ${SOFTWAREDIR}/${FMW_JAR} 


