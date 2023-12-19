#!/bin/bash
set -x

source ${WORKSPACE}/flywayscripts/R20.1.0.0.0_DEV.properties

#global variables
user="$1"
password="$5"
url="$4"
repo="$2"
env="$3"
echo -e "Deploying $env"
echo "ArtifactoryURL $4"
echo "Artifactory User key $5"

#get the latest services number and UI number from artifactory
SERVICE_NO=`curl -s -X GET -u $user:$password "$url/api/storage/$repo/app/core" | grep 'uri' | grep -v http | sed -r 's|.*/(.*)".*|\1|' | sort -n | tail -1`

javaNo=$SERVICE_NO


echo -e "Services Build Number $javaNo\n"

function removeCSV()
{
echo "removing csvs and jars"
rm -f ${WORKSPACE}/Admin.csv
rm -f ${WORKSPACE}/Clip.csv
rm -f ${WORKSPACE}/Entitlement.csv
rm -f ${WORKSPACE}/Resources.csv
rm -f ${WORKSPACE}/Day0Policy.csv
rm -f ${WORKSPACE}/Task.csv
rm -f ${WORKSPACE}/jars/SeedPolicies.jar
rm -f ${WORKSPACE}/jars/lib/com.ofss.digx.taskgen.jar
rm -f ${WORKSPACE}/jars/com.ofss.digx.utils.entitlement.feed.data.jar
rm -f ${WORKSPACE}/jars/com.ofss.digx.utils.feed.data.task.jar
rm -fr ${WORKSPACE}/jars/dashboard_json
rm -f ${WORKSPACE}/jars/dashboard_json.tar.gz
rm -f ${WORKSPACE}/jars/com.ofss.digx.utils.dashboard.jar
}


function download()
{
for i in Admin.csv Clip.csv Entitlement.csv Resources.csv Task.csv Day0Policy.csv
	do
		echo "downloading $i from Artifactory"
		curl -s -O -u $user:$password "$url/$repo/app/$env/$javaNo/$i"
		echo -e "$i downloaded successfully\n"
	done

cd ${WORKSPACE}/jars
echo "downloading SeedPolicies.jar from Artifactory"
curl -s -O -u $user:$password "$url/$repo/app/$env/$javaNo/SeedPolicies.jar"
echo -e "SeedPolicies.jar downloaded successfully\n"
echo "downloading com.ofss.digx.utils.entitlement.feed.data.jar from Artifactory"
curl -s -O -u $user:$password "$url/$repo/app/$env/$javaNo/com.ofss.digx.utils.entitlement.feed.data.jar"
echo -e "com.ofss.digx.utils.entitlement.feed.data.jar downloaded successfully\n"
echo "downloading com.ofss.digx.taskgen.jar from Artifactory"
curl -s -O -u $user:$password "$url/$repo/app/$env/$javaNo/com.ofss.digx.taskgen.jar"
echo -e "com.ofss.digx.taskgen downloaded successfully\n"
echo "downloading com.ofss.digx.utils.feed.data.task.jar from Artifactory"
curl -s -O -u $user:$password "$url/$repo/app/$env/$javaNo/com.ofss.digx.utils.feed.data.task.jar"
echo -e "com.ofss.digx.utils.feed.data.task.jar downloaded successfully\n"
echo "downloading com.ofss.digx.utils.dashboard.jar from Artifactory"
curl -s -O -u $user:$password "$url/$repo/app/$env/$javaNo/com.ofss.digx.utils.dashboard.jar"
echo -e "com.ofss.digx.utils.dashboard.jar downloaded successfully\n"
echo "downloading dashboard_json.tar.gz from Artifactory"
curl -s -O -u $user:$password "$url/$repo/app/$env/$javaNo/dashboard_json.tar.gz"
echo -e "dashboard_json.tar.gz downloaded successfully\n"
mv com.ofss.digx.taskgen.jar ${WORKSPACE}/jars/lib/
tar -zxvf ${WORKSPACE}/jars/dashboard_json.tar.gz
rm -fr ${WORKSPACE}/jars/dashboard_json/.svn

cd ${WORKSPACE}
}

removeCSV
download