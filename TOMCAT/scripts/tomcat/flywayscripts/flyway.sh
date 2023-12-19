#!/bin/bash

source /scratch/obdx/flywayscripts/R20.1.0.0.0_DEV.properties

flywayInstalltionUrl=https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/6.5.1/flyway-commandline-6.5.1-linux-x64.tar.gz

flywayInstalltion()
{
	if [[ -d "/scratch/obdx/flywayinstalltion" ]]; then
		echo "FLYWAY installtion already available"
	else
		export http_proxy="http://www-proxy.us.oracle.com:80"
		export https_proxy="http://www-proxy.us.oracle.com:80"
		#tar xvzf `wget $flywayInstalltionUrl`
		wget -qO- $flywayInstalltionUrl | tar xvz && mv `pwd`/flyway-6.5.1 /scratch/obdx/flywayinstalltion
	fi

}

flyway_config()
{
	FLYWAY_URL="$1"
	FLYWAY_USER="$2"
	FLYWAY_PASSWORD="$3"
	FLYWAY_SCHEMAS="$4"
	FLYWAY_PATH="/scratch/obdx/flywayinstalltion"
	
	echo "flyway.url=$FLYWAY_URL" >> /scratch/obdx/flywayscripts/flyway.conf
	echo "flyway.user=$FLYWAY_USER" >> /scratch/obdx/flywayscripts/flyway.conf
	echo "flyway.password=$FLYWAY_PASSWORD" >> /scratch/obdx/flywayscripts/flyway.conf
	echo "flyway.schemas=$FLYWAY_SCHEMAS" >> /scratch/obdx/flywayscripts/flyway.conf
}

flyway_execution()
{
	FLYWAY_PATH="/scratch/obdx/flywayinstalltion"
	echo "Executing scripts"
	sh -x $FLYWAY_PATH/flyway -configFiles=/scratch/obdx/flywayscripts/flyway.conf -locations="filesystem:$1" repair migrate
}

#Calling functions
#flywayInstalltion
flyway_config $DB_URL $DB_USER $DB_PASSWORD $DB_SCHEMA_NAME
flyway_execution /scratch/obdx/db_scripts/seed
flyway_execution /scratch/obdx/db_scripts/flyway