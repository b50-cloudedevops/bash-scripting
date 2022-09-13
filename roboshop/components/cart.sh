#!/bin/bash
set -e
source components/common.sh
COMPONENT=cart
FUSER=roboshop
echo -n " Configuring Yum repos for nodejs: "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash   >> /tmp/${COMPONENT}.log
stat $?
echo -n "Installing nodejs: "
yum install nodejs -y >> /tmp/${COMPONENT}.log
stat $?

echo -n " Adding ${FUSER} user: "
id ${FUSER} || useradd ${FUSER}
stat $?

echo -n "Downloading $COMPONENT: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Clean up of old $COMPONENT content:"
rm -rf /home/${FUSER}/${COMPONENT} >> /tmp/${COMPONENT}.log
stat $?

echo -n "Extracting $COMPONENT content: "
cd /home/${FUSER}
unzip -o /tmp/${COMPONENT}.zip >> /tmp/${COMPONENT}.log  &&  mv ${COMPONENT}-main ${COMPONENT}  >>  /tmp/${COMPONENT}.log
stat $?

echo -n "Changing the ownership to $FUSER: "
chown -R $FUSER:$FUSER $COMPONENT/

echo -n "Installing $COMPONENT Dependencies: "
cd $COMPONENT && npm install >> /tmp/${COMPONENT}.log
stat $?

echo -n "configuring the systemd file: "
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/${FUSER}/${COMPONENT}/systemd.service
mv /home/${FUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting the service: "
systemctl daemon-reload &>> /tmp/${COMPONENT}.log
systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log
