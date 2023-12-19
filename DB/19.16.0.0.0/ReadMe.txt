
Navigate to the directory were Dockerfile and script folder path
Run below command to build the docker Image
docker build --force-rm=true --no-cache=true  -t oracledb19_10  .
-t = Tag which you can give any name

once the Image is build then bring up the container using Docker image.

docker run -d -it --name ${ContaineName} -h obdxdb.in.oracle.com -v ${VM PATH}:/scratch/obdx -p 1521:1521 ${ImageName} /bin/bash

Example
docker run -d -it --name UBS_DB_183INS -h obdxdb.in.oracle.com -v /scratch/obdxdevops/OBDXINS_183:/scratch/obdx -p 1521:1521 oracledb19_10 /bin/bash

Post container is running connect to the container and execute below script

docker exec -itu devops ${ContaineName} /bin/bash

sh -x /home/devops/scripts/mainStart.sh
which will start the database and listner

Below script available at /home/devops/scripts

db_stop.sh -- To stop the database

db_start.sh -- To start the database 