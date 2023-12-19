#!/bin/bash

#Release=$1
ART_URL=$1
ART_USR_KEY=$2

#source ${WORKSPACE}/properties/common.properties


#decrypt passwords from property files
function decrypt_password(){
        while read line
                do
                        key=$( cut -d '=' -f 1 <<< "$line" )
                        value=$( cut -d '=' -f 2- <<< "$line" )
                        if [[ "$key" == *"PASSWORD" ]] && [[ "$value" != "" ]]; then
                                decryptedValue=`echo $value | openssl enc -aes-128-cbc -a -d -salt -pass pass:funit`
                                if [[ "$?" -eq 0 ]]; then
                                        newLine=$( echo "$key=$decryptedValue" | sed 's,\([]\#\*\$\/&[]\),\\\1,g' )
                                        sed -i "s#$line#$newLine#g" ${WORKSPACE}/flywayscripts/R20.1.0.0.0_DEV.properties
                                        #echo "Decryption successful for key : $key ; value : $value"
                                else
                                        echo "******** ERROR while decrypting key : $key ; value : $value ********"
                                        exit 1
                                fi
                        fi
                done < ${WORKSPACE}/flywayscripts/R20.1.0.0.0_DEV.properties  
	}
	
decrypt_password

source ${WORKSPACE}/flywayscripts/R20.1.0.0.0_DEV.properties



IT=$it_repo

rm -fr ${WORKSPACE}/*.log
rm -fr ${WORKSPACE}/*.txt
mkdir -p ${WORKSPACE}/jars
cp ${WORKSPACE}/policy/build.xml ${WORKSPACE}
cp ${WORKSPACE}/policy/*.sh ${WORKSPACE}
chmod -R 777 ${WORKSPACE}


sh +x ${WORKSPACE}/artifactory.sh $artJenkinsUsr $IT core $ART_URL $ART_USR_KEY

cd ${WORKSPACE}

