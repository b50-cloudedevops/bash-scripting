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
systemctl enable mysqld &>> ${LOGFILE}
systemctl start mysqld &>> ${LOGFILE}
stat $?


echo -n "fetching the default root password: "
DEFAULT_ROOT_PASSWORD=$(sudo grep temp /var/log/mysqld.log | head -n 1 | awk -F " " '{print $NF}')
stat $?

echo show databases | mysql -uroot -pRoboShop@1 | &>> ${LOGFILE}
if [ $? -ne 0 ]; then
 echo -n "reset root  password: "
 echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" &>> ${LOGFILE}
 stat $?
fi 

echo 'show plugins;' | mysql -uroot -pRoboShop@1 &>> ${LOGFILE} | grep validate_password > ${LOGFILE}
if [ $? -eq 0 ] ; then 
 echo -n "Uninstall the password validate plugin: "
 echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1 
 stat $?
fi

echo "downloading the schema:"
cd /tmp
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip" &>> ${LOGFILE} && unzip -o /tmp/mysql.zip
stat $?

echo -n "Load schema: "
cd /tmp/mysql-main/
mysql -uroot -pRoboShop@1 < shipping.sql &>> ${LOGFILE}
stat $?

echo "***********$COMPONENT Installation completed"