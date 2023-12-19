#!/bin/sh
set -e

exec /home/devops/jdk1.8.0_241/bin/java -Djenkins.install.runSetupWizard=false -Dhttp.proxyHost=www-proxy.us.oracle.com -Dhttp.proxyPort=80 -jar /scratch/app/product/jenkins.war