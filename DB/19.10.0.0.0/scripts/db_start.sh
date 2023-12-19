#!/bin/bash

echo "Setting ENV variables"
export ORACLE_BASE=/home/devops/app
export ORACLE_HOME=/home/devops/app/product/19.3.0.0/dbhome_1
export ORACLE_SID=obdx
export PATH=$PATH:$ORACLE_HOME/bin

echo "starting DB"
sqlplus / as sysdba << EOF
startup
exit;
EOF

lsnrctl start

