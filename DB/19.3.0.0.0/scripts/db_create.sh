# Create DB

export ORACLE_BASE=/home/devops/app           
export ORACLE_HOME=/home/devops/app/product/19.3.0.0/dbhome_1
export ORA_INVENTORY=/home/devops/oraInventory
export PATH=${ORACLE_HOME}/bin:${PATH}

dbca -silent                                          \
    -createDatabase                                   \
    -templateName General_Purpose.dbc                 \
    -gdbName obdx                             \
    -sid obdx                                \
    -sysPassword welcome1                     \
    -systemPassword welcome1                  \
    -emConfiguration NONE                             \
    -datafileDestination "/home/devops/app/oradata/" \
    -automaticMemoryManagement false                  \
    -totalMemory 1536                                 \
    -storageType FS                                   \
    -characterSet AL32UTF8


cp -rp /home/devops/scripts/listener.ora /home/devops/app/product/19.3.0.0/dbhome_1/network/admin/
cp -rp /home/devops/scripts/tnsnames.ora /home/devops/app/product/19.3.0.0/dbhome_1/network/admin/

#netca  -silent                                        \
#       -responseFile /home/devops/app/product/19.3.0/dbhome_1/assistants/netca/netca.rsp
