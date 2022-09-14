#!/bin/bash
source components/common.sh
COMPONENT=rabbitmq


echo -n "Installing  and configuring Erlnad dependency: "
yum install  https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>> $LOGFILE
curl -s -o https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n "Installing RabbitMq: "
yum install rabbitmq-server -y >> $LOGFILE
stat $? 

echo -n "starting $COMPONENT"
systemctl enable rabbitmq-server >> $LOGFILE
systemctl start rabbitmq-server >> $LOGFILE
stat $?

rabbitmqctl list_users | grep roboshop  &>> ${LOGFILE}
if [ $? -ne 0 ]; then
 echo -n "Creating $COMPONENT Application user: "
 rabbitmqctl add_user roboshop roboshop123
 stat $?
fi
echo -n "Configuring the $COMPONENT $FUSER permissions: "
rabbitmqctl set_user_tags roboshop administrator &>> ${LOGFILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOGFILE}
stat $?

