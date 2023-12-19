# Create DB

export ORACLE_BASE=$oracleDbBaseDir           
export ORACLE_HOME=$oracleDbHomeDir
export ORA_INVENTORY=$oraInventoryDir
export PATH=${ORACLE_HOME}/bin:${PATH}

dbca -silent                                          \
    -createDatabase                                   \
    -templateName General_Purpose.dbc                 \
    -gdbName $OracleSid                             \
    -sid $OracleSid                                \
    -sysPassword $SysPassword                     \
    -systemPassword $SysPassword                  \
    -emConfiguration NONE                             \
    -datafileDestination "$oracleDbBaseDir/oradata/" \
    -automaticMemoryManagement false                  \
    -totalMemory 1536                                 \
    -storageType FS                                   \
    -characterSet AL32UTF8


cp -rp $scriptsDir/listener.ora $oracleDbHomeDir/network/admin/
cp -rp $scriptsDir/tnsnames.ora $oracleDbHomeDir/network/admin/

#netca  -silent                                        \
#       -responseFile $oracleDbHomeDir/assistants/netca/netca.rsp
