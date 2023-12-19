# Set the base image to Oracle Linux 7 - Slim
FROM oraclelinux:7-slim

# File Author rajesh.nawale@oracle.com

LABEL maintainer=rajesh.nawale@oracle.com

# Define fixed (build time) environment variables.
ENV ORACLE_BASE=/home/devops/app                                      \
    ORACLE_HOME=/home/devops/app/product/19.3.0.0/dbhome_1            \
    ORA_INVENTORY=/home/devops/oraInventory     \
    SOFTWARE_DIR=/home/devops/software                                             \
    SCRIPTS_DIR=/home/devops/scripts                                          \
    ORAENV_ASK=NO                                                      \
    ORACLE_SID=obdx                                                   \
    SYS_PASSWORD=welcome1    \
	USER_HOME=/home/devops     \
	PATH=/home/devops/app/product/19.3.0.0/dbhome_1/bin:$PATH

RUN echo "enableProxy=1" >> /etc/yum.conf                                  && \
    echo "proxy=http://www-proxy.idc.oracle.com:80" >> /etc/yum.conf        && \
    yum -y install unzip tar procps gzip vim bc binutils compat-libcap1 compat-libstdc++-33 dtrace-utils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libdtrace-ctf-devel libXrender libXrender-devel libX11 libXau libXi libXtst libgcc librdmacm-devel libstdc++ libstdc++-devel libxcb make net-tools nfs-utils python python-configshell python-rtslib python-six targetcli smartmontools sysstat unixODBC wget oracle-database-preinstall-19c && \
    groupadd -g 1000 devops && \
    useradd -d /home/devops -u 1000 -g devops -G dba,oper -m -s /bin/bash devops  && \
    rm -Rf /var/cache/yum     && \
	mkdir -p ${SCRIPTS_DIR}   && \
    mkdir -p /scratch/obdx							 && \
    mkdir -p /scratch/obdx/oradata                                            && \
    chmod -R 755 ${SCRIPTS_DIR}/                                         && \
    chown -R devops.dba ${USER_HOME}                         && \
	chown -R devops.dba ${SCRIPTS_DIR}  					 &&\
    chmod 775 ${USER_HOME}                                                && \
    chmod g+s ${USER_HOME}										

COPY scripts/* ${SCRIPTS_DIR}/


# Perform the following actions as the oracle user
USER devops

# Unzip software
RUN mkdir -p ${ORACLE_HOME}   &&\
    mkdir -p ${SOFTWARE_DIR}  &&\
	cd ${SOFTWARE_DIR} && \
    wget http://whf00jeo:8080/software/DB/LINUX.X64_193000_db_home.zip && \
	cd ${ORACLE_HOME}				&& \
    unzip -oq ${SOFTWARE_DIR}/LINUX.X64_193000_db_home.zip     && \
    rm -rf ${SOFTWARE_DIR}/LINUX.X64_193000_db_home.zip            && \
    ${ORACLE_HOME}/runInstaller -ignorePrereq                                  \
    -waitforcompletion -silent                                                 \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp               \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME=obdxdb.in.oracle.com                                       \
    UNIX_GROUP_NAME=dba                                                        \
    INVENTORY_LOCATION=${ORA_INVENTORY}                                       \
    SELECTED_LANGUAGES=en,en_GB                                                \
    ORACLE_HOME=${ORACLE_HOME}                                               \
    ORACLE_BASE=${ORACLE_BASE}                                                \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.OSDBA_GROUP=dba                                          \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
    oracle.install.db.OSDGDBA_GROUP=dba                                        \
    oracle.install.db.OSKMDBA_GROUP=dba                                        \
    oracle.install.db.OSRACDBA_GROUP=dba                                       \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true; exit 0


# Run the root scripts
USER root

RUN sh ${ORACLE_HOME}/root.sh                                     && \
	sh ${ORA_INVENTORY}/orainstRoot.sh

# Perform the following actions as the oracle user
USER devops

RUN sh ${SCRIPTS_DIR}/db_create.sh

# Set base directory
# # ------------------
WORKDIR ${USER_HOME}

VOLUME ["/scratch/obdx"]
EXPOSE 1521 1521
HEALTHCHECK --interval=5m --start-period=10m \
   CMD lsnrctl status | grep '"${ORACLE_SID}", status READY' && exit 0
#
