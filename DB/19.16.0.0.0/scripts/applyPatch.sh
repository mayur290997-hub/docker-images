# Patch database binaries with patch sets
#cd $PATCH_DIR/
#ls

# Apply Patach 6880880
cp -r $ORACLE_HOME/OPatch/ $ORACLE_HOME/OPatch_32218454
rm -rf $ORACLE_HOME/OPatch
# Move new OPatch folder into ORACLE_HOME
cp -r $PATCH_DIR/6880880/OPatch $ORACLE_HOME/
# Apply patch
#   opatch apply -silent
   # Get return code
   return_code=$?
   # Error applying the patch, abort
   if [ "$return_code" != "0" ]; then
      exit $return_code;
	  echo "##### 6880880 failed ######"
   fi;

export ORACLE_HOME=/home/devops/app/product/19.3.0.0/dbhome_1
export PATH=/home/devops/app/product/19.3.0.0/dbhome_1/OPatch:$PATH

cd $PATCH_DIR/32218454/32218454/
# install newer OPatch version 
# Backup & Remove old OPatch folder
# Apply Patach 32218454
   opatch prereq CheckConflictAgainstOHWithDetail -ph ./	
   opatch apply -silent
   # Get return code
   return_code=$?
   # Error applying the patch, abort
   if [ "$return_code" != "0" ]; then
      exit $return_code;
   fi;


 # Apply Patach 29997937
#cp $ORACLE_HOME/OPatch $ORACLE_HOME/OPatch_6880880
#rm -rf $ORACLE_HOME/OPatch
## Move new OPatch folder into ORACLE_HOME
cd $PATCH_DIR/33515361/33515361/
## Apply patch
   opatch prereq CheckConflictAgainstOHWithDetail -ph ./
   opatch apply -silent
#   # Get return code
   return_code=$?
#   # Error applying the patch, abort
   if [ "$return_code" != "0" ]; then
      exit $return_code;
   fi;

#sh -x ${SCRIPTS_DIR}/db_start.sh


running=`ps -ef | grep -i pmon_obdx | grep -v grep | awk -F_ '{ print $3 }'|wc -l`
if [ "$running" != 0 ] ; then
  echo " obdx database is already started."
  echo "Setting ENV variables"
   export ORACLE_BASE=/home/devops/app
   export ORACLE_HOME=/home/devops/app/product/19.3.0.0/dbhome_1
   export ORACLE_SID=obdx
   export PATH=$PATH:$ORACLE_HOME/bin
cd /home/devops/app/product/19.3.0.0/dbhome_1/rdbms/admin
  sqlplus / as sysdba << EOF

	STARTUP UPGRADE;

	DECLARE
	  l_tz_version PLS_INTEGER;
	BEGIN
	  l_tz_version := DBMS_DST.get_latest_timezone_version;
	 
	  DBMS_OUTPUT.put_line('l_tz_version=' || l_tz_version);
	  DBMS_DST.begin_prepare(l_tz_version);
	END;
	/  

	EXEC DBMS_DST.find_affected_tables;

	EXEC DBMS_DST.end_prepare;
	
	@utlrp.sql

	SHUTDOWN IMMEDIATE;

EOF
  exit 1;

else 
  echo "Database obdx is not running"
#  sh -x ${SCRIPTS_DIR}/db_start.sh

echo "Setting ENV variables"
export ORACLE_BASE=/home/devops/app
export ORACLE_HOME=/home/devops/app/product/19.3.0.0/dbhome_1
export ORACLE_SID=obdx
export PATH=$PATH:$ORACLE_HOME/bin
cd /home/devops/app/product/19.3.0.0/dbhome_1/rdbms/admin
  sqlplus / as sysdba << EOF

	STARTUP UPGRADE;

	DECLARE
	  l_tz_version PLS_INTEGER;
	BEGIN
	  l_tz_version := DBMS_DST.get_latest_timezone_version;
	 
	  DBMS_OUTPUT.put_line('l_tz_version=' || l_tz_version);
	  DBMS_DST.begin_prepare(l_tz_version);
	END;
	/  

	EXEC DBMS_DST.find_affected_tables;

	EXEC DBMS_DST.end_prepare;

	@utlrp.sql
	
	SHUTDOWN IMMEDIATE;
	
EOF
  
fi

