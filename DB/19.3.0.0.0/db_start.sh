#!/bin/bash

echo "Setting ENV variables"
export ORACLE_BASE=$oracleDbBaseDir
export ORACLE_HOME=$oracleDbHomeDir
export ORACLE_SID=$OracleSid
export PATH=$PATH:$ORACLE_HOME/bin

echo "starting DB"
sqlplus / as sysdba << EOF
startup
exit;
EOF

lsnrctl start
