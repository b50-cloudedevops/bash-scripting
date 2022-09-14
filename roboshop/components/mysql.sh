#!/bin/bash

set -e

source components/common.sh

COMPONENT=mysql
LOGFILE=/tmp/robot.log

echo -n "configuring the $COMPONENT repo:"

curl -s -L -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo >> ${LOGFILE}
stat $?

echo -n "Installing $COMPONENT: "
yum install mysql-community-server -y >> ${LOGFILE}
stat $?

echo -n "Starting ${COMPONENT} : "
systemctl enable mysqld >> ${LOGFILE}
systemctl start mysqld >> ${LOGFILE}
stat $?

