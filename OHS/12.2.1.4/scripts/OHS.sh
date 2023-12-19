#!/bin/bash
#Global variables
OHS_DOMAIN=/home/devops/Oracle/Middleware/Oracle_Home/user_projects/domains/ohs_domain
OHS_HOSTNAME=obdxohs.in.oracle.com
OHS_PORT=7777
OHS_INSTANCE=ohs1
SCRIPT_PATH=/home/devops/scripts
FLAVOR=$2

#Function declaration

# Start node manager

save_config(){

${OHS_DOMAIN}/bin/startNodeManager.sh > ${OHS_DOMAIN}/nodemanager/nodemanager$$.log 2>&1 &

echo "welcome1" | sh ${OHS_DOMAIN}/bin/startComponent.sh $OHS_INSTANCE storeUserConfig

shutdown

}

stop_nodemgr(){
    echo "Shutting down NodeManager"
    pid=`ps axf | grep weblogic.NodeManager | grep -v grep | awk '{print $1}'`
    kill -9 $pid

    i=`ps -ef|grep weblogic.NodeManager |grep -v grep|wc -l`

        if [ $i -eq 0 ]; then
                echo "NodeManager Shutdown complete"
                break;
        else
         echo "NodeManager shutdown failed"
     fi
}

start_nodemgr(){
        echo "Checking current state of NodeManager"
        i=`ps -ef|grep weblogic.NodeManager |grep -v grep|wc -l`
        if [ $i -gt 0 ]; then
                echo "NodeManager already running"
                break;
        else
        echo "Starting NodeManager Service"
        #python -c 'import NODE; NODE.start_node_manager()'
        python $SCRIPT_PATH/NODE.py
fi
}

cleanup(){
        echo "Cleaning up log files"
        rm -fr ${OHS_DOMAIN}/servers/$OHS_INSTANCE/logs/*log*
        rm -fr /scratch/obdx/ohs/logs/*
        rm -fr /tmp/*
        echo "Clean-up complete"
}

startup(){
        start_nodemgr
        i=1
        sh ${OHS_DOMAIN}/bin/startComponent.sh $OHS_INSTANCE

         until curl -s -o /dev/null -w "%{http_code}" http://${OHS_HOSTNAME}:${OHS_PORT} | grep '200'; do
                date '+[%Y-%m-%d %H:%M:%S] --- OHS is starting, please wait...'
                sleep 10
                i=$(( i+1 ))

                if [ $i -gt 5 ]; then
                 echo "OHS failed to start. Please check respective log files"
                 break;
                fi
         done
         check_status
}

shutdown(){
        ${OHS_DOMAIN}/bin/stopComponent.sh $OHS_INSTANCE
        i=`ps -ef|grep $OHS_INSTANCE |grep -v grep|wc -l`
        if [ $i -gt 0 ]; then
                echo "OHS failed to stop"
                break;
        else
        echo "OHS down"
        fi
        check_status
        stop_nodemgr
}

check_status(){

        httpcode=`curl -s -o /dev/null -w "%{http_code}" http://${OHS_HOSTNAME}:${OHS_PORT}`

        if [ $httpcode != "200" ]
        then
        echo "OHS Server is down"
        else
        echo "OHS Server is up"
        fi
}

flavor_config(){

        echo "Configuration change for $FLAVOR in UI files (constants.js and manifest)"
        if [ $FLAVOR == "OBP" ] || [ $FLAVOR == "FLL" ]
        then
                sed -i -e "s#<Authenticator>#OBDXAuthenticator#" /scratch/obdx/ohs/deploy/framework/js/constants/constants.js
                sed -i -e "s#<HOST_ID>#obp#" /scratch/obdx/ohs/deploy/framework/js/constants/constants.js
        else
                sed -i -e "s#<Authenticator>#OBDXAuthenticator#" /scratch/obdx/ohs/deploy/framework/js/constants/constants.js
                sed -i -e "s#<HOST_ID>#fcubs#" /scratch/obdx/ohs/deploy/framework/js/constants/constants.js
        fi

        if [ $FLAVOR == "OBP" ]
        then
                echo -ne "alpha" > /scratch/obdx/ohs/deploy/lzn/manifest
        fi

        if [ $FLAVOR == "FLL" ]
        then
                echo -ne "gamma" > /scratch/obdx/ohs/deploy/lzn/manifest
        fi

        echo "Configuration changes completed for $FLAVOR in UI files (constants.js and manifest)"
}


usage()
{
  echo 'OHS.sh script to be used for maintenance activities'
  echo 'Usage : OHS.sh <action>'
  echo 'Actions :'
  echo 'cleanup : To cleanup log files'
  echo 'startup : To start OHS component'
  echo 'shutdown : To shutdown OHS component'
  echo 'stop_nodemgr: To stop Node manager'
  echo 'start_nodemgr: To start Node manager'
  echo 'check_status : To get current status of OHS server'
  echo 'for example : sh +x OHS.sh cleanup'
  exit
}


#Calling Functions

if [[ $1 = "cleanup" || $1 = "startup" || $1 = "shutdown" || $1 = "check_status" || $1 = "flavor_config" || $1 = "stop_nodemgr" || $1 = "start_nodemgr" || $1 = "save_config" ]] ; then
        $1
else
        usage
fi
