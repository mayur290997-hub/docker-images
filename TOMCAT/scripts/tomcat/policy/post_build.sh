#!/bin/bash

cd ${WORKSPACE}

Task_log=$(cat Task.log | grep -i SEVERE | wc -l)
Entitlement_log=$(cat Entitlement.log | grep -i SEVERE | wc -l )
Dashboard_log=$(cat Dashboard.log | grep -i SEVERE | wc -l )

if [ "$Task_log" -ge 1 ] || [ "$Entitlement_log" -ge 1 ] ||  [ "$Dashboard_log" -ge 1 ] ; 
then
if [ "$Task_log" -ge 1 ] ;
then
Task_severity=$(cat Task.log | grep -i SEVERE)
echo "Task_severity=$Task_log SEVERE ERROR'S FOUND" > ${WORKSPACE}/Task.properties
else
echo "Task_severity=SEVERE ERROR'S NOT FOUND" > ${WORKSPACE}/Task.properties
fi
if [ "$Entitlement_log" -ge 1 ] ;then
Entitlement_severity=$(cat Entitlement.log | grep -i SEVERE)
echo "Entitlement_severity=$Entitlement_log SEVERE ERROR'S FOUND" > ${WORKSPACE}/Ent.properties
else
echo "Entitlement_severity=SEVERE ERROR'S NOT FOUND" > ${WORKSPACE}/Ent.properties
fi
if  [ "$Dashboard_log" -ge 1 ] ;then
Dashboard_severity=$(cat Dashboard.log | grep -i SEVERE)
echo "Dashboard_severity=$Dashboard_log SEVERE ERROR'S FOUND"  > ${WORKSPACE}/Dashboard.properties
else
echo "Dashboard_severity=SEVERE ERROR'S NOT FOUND" > ${WORKSPACE}/Dashboard.properties
fi
exit 1
else
echo "No SEVERE issues found"
exit 0
fi

rm -rf ${WORKSPACE}/properties