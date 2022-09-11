#!/bin/bash

source components/common.sh
COMPONENT=mongodb
echo -n "configuring mongodb repo: "
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $?
echo -n "Installing the ${COMPONENT}: "
yum install -y mongodb-org >> /tmp/${COMPONENT}.log
stat $?
echo -n "Updating the $COMPONENT configuration:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?
echo -n "starting the $COMPONENT service"
systemctl enable mongod >> /tmp/${COMPONENT}.log
systemctl start mongod
stat $?

echo -n "downloading the schema: "
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?
echo -n "Extracting the $COMPONENT schema: "
cd /tmp && unzip mongodb.zip && cd mongodb-main
stat $?
echo -n "Injecting the $COMPONENT schema: "
mongo < catalogue.js && mongo < users.js
stat $?
echo "****************___________________$COMPONENT Completed_____________________********************"