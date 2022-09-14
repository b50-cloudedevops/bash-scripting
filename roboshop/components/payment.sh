#!/bin/bash
set -e
source components/common.sh
COMPONENT=payment

echo -n "Installing python!: "
yum install python36 gcc python3-devel -y >> ${LOGFILE}
stat $?

USER_SETUP

DOWNLOAD_AND_EXTRACT

cd /home/${FUSER}/${COMPONENT}
pip3 install -r requirements.txt >> ${LOGFILE}
stat $?

USER_ID=${id -u roboshop}
GROUP_ID=${id -g roboshop}

echo -n "Updating the $COMPONENT file: "
sed -e "/^uid/ c uid=${USER_ID}" -e "/^gid/ c gid=${GROUP_ID}" payment.ini 
stat $?
CONFIG_SVC
