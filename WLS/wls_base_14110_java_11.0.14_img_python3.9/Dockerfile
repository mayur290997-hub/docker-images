FROM container-registry.oracle.com/os/oraclelinux:8-slim

MAINTAINER DevOps <digital_devops_in_grp@oracle.com>

RUN groupadd -g 1000 devops && \
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
    microdnf install -y python3 python3-devel python3-libs python3-pip python3-setuptools dnf yum && \
    microdnf install -y procps curl hostname vi vim wget zip unzip bzip2 nc net-tools tar && \
    microdnf clean all  && \
    microdnf install -y jq  && \ 
    wget -nv --no-proxy http://100.76.146.17:9090/software/WLS/oracle-instantclient-basic-21.11.0.0.0-1.x86_64.rpm && \
    dnf install -y oracle-instantclient-basic-21.11.0.0.0-1.x86_64.rpm && \
    rm -v oracle-instantclient-basic-21.11.0.0.0-1.x86_64.rpm && \
    python3 -m pip install cx_Oracle==8.3.0 urwid==2.1.2 wget requests 

USER devops

ENV USR_HOME=/home/devops               \
    JAVA_HOME=/scratch/app/java         \
    GRADLE_HOME=/scratch/app/gradle         \
    ORACLE_HOME=/scratch/app/product/Oracle/Middleware/Oracle_Home \
    SOFTWAREDIR=/scratch/app      \
    FLYWAY_HOME=/scratch/app/flyway \
    FMW_JAR=fmw_14.1.1.0.0_wls_lite_generic.jar \
    LD_LIBRARY_PATH=/usr/lib/oracle/19.10/client64/lib/:$LD_LIBRARY_PATH

RUN mkdir -p ${SOFTWAREDIR} &&\
    chmod 777 ${SOFTWAREDIR} &&\
    mkdir -p ${JAVA_HOME} &&\
    mkdir -p  ${FLYWAY_HOME} &&\
    mkdir -p  ${GRADLE_HOME} &&\
    cd ${SOFTWAREDIR} &&\
    wget -nv --no-proxy http://100.76.146.17:9090/software/WLS/gradle-8.3-all.zip &&\
    unzip gradle-8.3-all.zip &&\
    mv -v gradle-8.3/*  ${GRADLE_HOME} &&\
    rm -rvf gradle-8.3 &&\
    chmod -R 755 ${GRADLE_HOME} && \
    rm -rfv gradle-8.3-all.zip &&\
    wget -nv --no-proxy http://100.76.146.17:9090/software/JAVA/jdk-11.0.14_linux-x64_bin.tar.gz &&\
    tar -xvf jdk-11.0.14_linux-x64_bin.tar.gz &&\
    mv -v jdk-11.0.14/*  ${JAVA_HOME} &&\
    rm -rvf jdk-11.0.14 &&\
    chmod -R 755 ${JAVA_HOME} && \
    rm -rfv jdk-11.0.14_linux-x64_bin.tar.gz &&\
    wget -nv --no-proxy http://100.76.146.17:9090/software/FLYWAY/9.22.3/flyway-commandline-9.22.3-linux-x64.tar.gz &&\
    tar -xvf flyway-commandline-9.22.3-linux-x64.tar.gz &&\
    mv -v flyway-9.22.3/*   ${FLYWAY_HOME}  &&\
    rm -r flyway-9.22.3 && \
    chmod -R 755 ${FLYWAY_HOME} && \
    rm -rfv flyway-commandline-9.22.3-linux-x64.tar.gz &&\
    wget -nv --no-proxy http://100.76.146.17:9090/software/WLS/${FMW_JAR} &&\
    chmod 755 ${SOFTWAREDIR}/${FMW_JAR} && \
    cd ${USR_HOME} &&\ 
    wget -nv --no-proxy http://100.76.146.17:9090/software/WLS/install.file &&\ 
    wget -nv --no-proxy http://100.76.146.17:9090/software/WLS/oraInst.loc 

RUN $JAVA_HOME/bin/java -jar  ${SOFTWAREDIR}/${FMW_JAR} -silent -responseFile ${USR_HOME}/install.file -invPtrLoc ${USR_HOME}/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server"  && \
rm -rfv ${SOFTWAREDIR}/${FMW_JAR}
