#!/bin/bash

source components/common.sh
COMPONENT=mongodb
echo -n "configuring mongodb repo: "
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $?
echo -n "Installing the ${COMPONENT}: "
yum install -y mongodb-org 
stat $?
echo -n "Updating the $COMPONENT configuration:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?
echo -n "starting the $COMPONENT service"
systemctl enable mongod >> /tmp/${COMPONENT}.log
systemctl start mongod
stat $?