#!/bin/bash

ARTIFACTORY_REPO="http://whf00mja.in.oracle.com:8082/artifactory"
artrepo="OBDX/R20.1.0.0.0_DEV/app/core"
artJenkinsUsr=jenkins
ART_USR_KEY=AP9AHcxovbyptn5fLBNbsdi5UGM
artHostName=whf00mja
tomcatbasePath=/scratch/app/product
tomcatVersion=apache-tomcat-9.0.35
tomcatHomePath=$tomcatbasePath/$tomcatVersion
javaHome=/home/devops/jdk1.8.0_241

#functions
wait_for_shutdown() {

 i=1
 while [ $i -le 30 ]
    do
    ps -ef | grep catalina.startup.Bootstrap > test.txt
    if ls -l test.txt | grep 8080
    then
       i=21
    else
       i=`expr $i + 1`
       sleep 1
    fi
 done
}


do_shutdown() {

    export JAVA_HOME=$javaHome
    export PATH=$JAVA_HOME/bin:$PATH
    cd $tomcatHomePath
    bin/shutdown.sh

    wait_for_shutdown
	ps -ef | grep java | grep -v grep | awk '{print $2}'| xargs kill -9

}

clean_directories() {
    DATE=`date '+%d-%h-%Y' | tr [:lower:] [:upper:]`
    echo "changing directory"
    cd $tomcatHomePath/webapps
    pwd
    echo "Taking backup of war file"
    mv digx.war digx.war.${DATE}.bkp
    mv digx-auth.war digx-auth.war.${DATE}.bkp

}

get_digx_auth_war_file() {

cd $tomcatHomePath/webapps
echo "Getting clip-auth war file"
latest_build_no=$(curl -s -X GET -u $artJenkinsUsr:$ART_USR_KEY "$ARTIFACTORY_REPO/api/storage/OBDX/R20.1.0.0.0_DEV/auth" | grep 'uri' | grep -v $artHostName | sed -r 's|.*/(.*)".*|\1|' | sort -n | tail -1)
curl -s -O -u $artJenkinsUsr:$ART_USR_KEY "$ARTIFACTORY_REPO/OBDX/R20.1.0.0.0_DEV/auth/$latest_build_no/digx-auth.war"

}

start_server() {
    export JAVA_HOME=$javaHome
    export PATH=$JAVA_HOME/bin:$PATH
    cd $tomcatHomePath
    pwd
    bin/startup.sh

}

start_debug(){

    export JAVA_HOME=$javaHome
    export PATH=$JAVA_HOME/bin:$PATH
	export JPDA_ADDRESS=8000
	export JPDA_TRANSPORT=dt_socket
	cd $tomcatHomePath
	bin/catalina.sh jpda start
	
}

help (){

if [ $# -lt 2 ]
then
    echo "Usage : $0 deployWar release"
    echo "Usage : $0 deployWar EE|FE"
    exit
fi

}

do_shutdown
clean_directories
get_digx_auth_war_file
do_shutdown
start_server



