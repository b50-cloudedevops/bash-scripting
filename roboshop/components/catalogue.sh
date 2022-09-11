#!/bin/bash
set -e
source components/common.sh
COMPONENT=catalogue
FUSER=roboshop
echo -n " Configuring Yum repos for nodejs: "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash   >> /tmp/${COMPONENT}.log
stat $?
echo -n "Installing nodejs: "
yum install nodejs -y >> /tmp/${COMPONENT}.log
stat $?

echo -n " Adding ${FUSER} user: "
id ${FUSER} || useradd ${COMPONENT}
stat $?

echo -n "Downloading $COMPONENT: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "CLeanup of old ${COMPONENT} content: "
rm -rf /home/${FUSER}/${COMPONENT} >> /tmp/${COMPONENT}.log
stat $?

echo -n "Extracting $COMPONENT content: "
cd /home/${FUSER} >> /tmp/${COMPONENT}.log
unzip -o /tmp/${COMPONENT}.zip >> /tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} >> /tmp/${COMPONENT}.log
stat $?

echo -n "Changing the ownership to $FUSER: "
chown $FUSER:$FUSER $COMPONENT/

cd /home/roboshop/catalogue


echo -n "Installing $COMPONENT Dependencies: "
npm install >> /tmp/${COMPONENT}.log
stat $?