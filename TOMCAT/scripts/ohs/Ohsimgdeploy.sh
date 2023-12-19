#!/bin/bash

artifactoryUrl=http://whf00mja.in.oracle.com:8082/artifactory
artifactoryRepo=OBDX/R20.1.0.0.0_DEV
artifactoryUser=jenkins
artfactoryApiKey=AP9AHcxovbyptn5fLBNbsdi5UGM
tomcatPort=6060
tomcatServerHostname=whf00lse.in.oracle.com


Build_no=$(curl -s -X GET -u $artifactoryUser:$artfactoryApiKey "$artifactoryUrl/api/storage/$artifactoryRepo/UI/core" | grep 'uri' | grep -v 'http' | sed -r 's|.*/(.*)".*|\1|' | sort -n | tail -1)

curl -s -O -u "$artifactoryUser:$artfactoryApiKey" -o ./scripts.zip $artifactoryUrl/Devops_Utils/DummyRepo/scripts.zip
curl -s -O -u "$artifactoryUser:$artfactoryApiKey" -o ./config.tar.gz $artifactoryUrl/$artifactoryRepo/UI/core/$Build_no/config.tar.gz
curl -s -O -u "$artifactoryUser:$artfactoryApiKey" -o ./dist.tar.gz $artifactoryUrl/$artifactoryRepo/UI/core/$Build_no/dist.tar.gz

unzip scripts.zip
tar -xvzf dist.tar.gz
tar -xvzf config.tar.gz
mv dist deploy
chmod -R 777 config deploy scripts
cp -r /home/devops/obdx/scripts/* /home/devops/
rm -rf dist.tar.gz config.tar.gz scripts.zip scripts


chmod -R 777 config deploy
#mkdir obdx
sed -i "s#<CHANNEL_PATH>#/scratch/obdx/ohs/deploy#g" /home/devops/obdx/config/obdx.conf
sed -i 's/#\Require/\Require/g' /home/devops/obdx/config/obdx.conf
sed -i "s#<Authenticator>#JWTAuthenticator#g" /home/devops/obdx/deploy/framework/js/constants/constants.js
sed -i "s#OBDXAuthenticator#JWTAuthenticator#g" /home/devops/obdx/deploy/framework/js/configurations/config.js
sed -i "s#<MS_PORT>#$tomcatPort#g" /home/devops/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.conf
sed -i "s#mum00adz.in.oracle.com#$tomcatServerHostname#g" /home/devops/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.conf
sed -i "s#</IfModule>##g" /home/devops/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.conf
echo ' MatchExpression /digx-auth/*' >> /home/devops/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.conf
echo '</IfModule>' >> /home/devops/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/config/fmwconfig/components/OHS/instances/ohs1/mod_wl_ohs.conf
sed -i "s#/scratch/ohs/config/obdx.conf#/scratch/obdx/ohs/config/obdx.conf#g" /home/devops/Oracle/Middleware/Oracle_Home/user_projects/domains/base_domain/config/fmwconfig/components/OHS/instances/ohs1/httpd.conf
mkdir -p /scratch/obdx/ohs/
cp -r /home/devops/obdx/* /scratch/obdx/ohs/
