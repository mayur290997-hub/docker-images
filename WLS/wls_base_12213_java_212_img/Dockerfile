FROM container-registry.oracle.com/os/oraclelinux:7-slim

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
    yum -y install oracle-epel-release-el7 oracle-release-el7 && yum-config-manager --enable oracle-epel-release-el7 && \
    yum -y install procps curl hostname vi vim wget zip unzip bzip2 nc net-tools && \
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm && \
    yum -y install oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm && \
    rm -v oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm  && \
    export http_proxy="http://www-proxy.us.oracle.com:80/" && \
    export https_proxy="http://www-proxy.us.oracle.com:80/" && \
    yum -y install python-pip  python3   && \
    ##python -m pip install cx_Oracle==7.3 urwid==1.3.1 wget requests  && \
    python3 -m pip install cx_Oracle==7.3 urwid==2.1.0 wget requests 

USER devops

ENV USR_HOME=/home/devops               \
    JAVA_HOME=/scratch/app/java         \
    ORACLE_HOME=/scratch/app/product/Oracle/Middleware/Oracle_Home \
    SOFTWAREDIR=/scratch/app      \
    FMW_JAR=fmw_12.2.1.3.0_infrastructure.jar \
    LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib/:$LD_LIBRARY_PATH

RUN mkdir -p ${SOFTWAREDIR} &&\
    mkdir -p ${JAVA_HOME} &&\
    cd ${SOFTWAREDIR} &&\
    wget -nv  --no-proxy http://whf00jeo.in.oracle.com:8080/software/JAVA/jdk-8u212-linux-x64.tar.gz &&\
    tar -xvf jdk-8u212-linux-x64.tar.gz &&\
    mv -v jdk1.8.0_212/* ${JAVA_HOME} &&\
    rm -rvf jdk1.8.0_212 &&\ 
    chmod -R 755 ${JAVA_HOME} && \
    rm -rvf jdk-8u212-linux-x64.tar.gz &&\
    wget -nv --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/${FMW_JAR} &&\
    chmod 755 ${SOFTWAREDIR}/${FMW_JAR} && \
    cd ${USR_HOME} &&\ 
    wget  --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/install.file &&\ 
    wget  --no-proxy http://whf00jeo.in.oracle.com:8080/software/WLS/oraInst.loc 

RUN $JAVA_HOME/bin/java -jar  ${SOFTWAREDIR}/${FMW_JAR} -silent -responseFile ${USR_HOME}/install.file -invPtrLoc ${USR_HOME}/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server"  && \
rm -rfv ${SOFTWAREDIR}/${FMW_JAR} 

