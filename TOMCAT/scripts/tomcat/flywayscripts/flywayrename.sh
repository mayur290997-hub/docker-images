#!/bin/bash

source ${WORKSPACE}/flywayscripts/R20.1.0.0.0_DEV.properties

function svn_checkout()
{
		rm -rf ${WORKSPACE}/checkout/obdx
		rm -rf ${WORKSPACE}/checkout/flyway
		
        echo "checkout code for $Release"
		mkdir -p ${WORKSPACE}/checkout/obdx
		
		cd ${WORKSPACE}/checkout/obdx
		
		if [[ $Date_from_script_need_exec == "" ]]
		then 
			from_revision=$(date -d '-2 day' '+%Y-%m-%d')
			Date_from_script_need_exec=$from_revision
		else
			Date_from_script_need_exec=$Date_from_script_need_exec
		fi	
			base_revison=$(svn log -v -r{$Date_from_script_need_exec}:HEAD svn+ssh://$svnUsr@$svnUrl/branches/$Release/core/patch_incrementals/obdx | head -2 | awk '{print $1}' | egrep -o "[0-9]+")
		
			for i in $(svn diff --summarize -r $base_revison:HEAD svn+ssh://$svnUsr@$svnUrl/branches/$Release/core/patch_incrementals/obdx | awk '{ print $2 }'); do p=$(echo $i | sed -e 's{svn+ssh://'"$svnUsr"'@'"$svnUrl"'/branches/'"$Release"'/core/patch_incrementals/obdx/{{');mkdir -p $(dirname ${WORKSPACE}/checkout/obdx/$p); svn export $i ${WORKSPACE}/checkout/obdx/$p; done
			
			svn log -v -r $base_revison:HEAD svn+ssh://$svnUsr@$svnUrl/branches/$Release/core/patch_incrementals/obdx > ${WORKSPACE}/checkout/revision.log
	
				
}

flyway_file_rename()
{
checkout_path=$1
product_id=$2
product_version=$3

python ${WORKSPACE}/flywayscripts/flywayVersioning.py $checkout_path $product_id $product_version
}

genericrest_rename()
{
rm -rf ${WORKSPACE}/genericrest.tar.gz
rm -rf ${WORKSPACE}/genericrest

curl -X GET -u $artJenkinsUsr:$API_KEY -o ${WORKSPACE}/genericrest.tar.gz  "$ARTIFACTORY_REPO/$artrepo/utils/Extensibility/genericrest.tar.gz"

tar -zxvf ${WORKSPACE}/genericrest.tar.gz  -C ${WORKSPACE}

cd ${WORKSPACE}/genericrest/seed

rm Generic_scripts_master.sql

find . -type f -name '*.sql' | while IFS= read file_name; do baseDir=$(echo "$(dirname $file_name)"); basename=$(echo "$(basename $baseDir)"); mv "$file_name" "$(dirname $file_name)/R__${basename}_${file_name##*\/}"; done
}

#Caling Functions
svn_checkout
flyway_file_rename ${WORKSPACE}/checkout $ProductID $ReleaseVersion
genericrest_rename