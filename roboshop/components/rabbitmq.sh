#!/bin/bash
set -e
source components/common.sh
COMPONENT=rabbitmq


echo -n "Installing Erlnad dependency: "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>> $LOGFILE
stat $?

echo -n "Configuring the yum repo for $COMPONENT"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n "Installing RabbitMq: "
yum install rabbitmq-server -y >> $LOGFILE
stat $?

echo -n "starting $COMPONENT"
systemctl enable rabbitmq-server >> $LOGFILE
systemctl start rabbitmq-server >> $LOGFILE
stat $?


echo -n "Creating $COMPONENT Application user: "
rabbitmqctl add_user roboshop roboshop123
stat $?

echo -n "Configuring the $COMPONENT $FUSER permissions: "
rabbitmqctl set_user_tags roboshop administrator &>> ${LOGFILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
stat $?

