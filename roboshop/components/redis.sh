#!/bin/bash
set -e
source components/common.sh
COMPONENT=redis
echo -n "Configuring the $COMPONENT repo: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?

echo -n "Installing $COMPONENT-:  "
yum install redis-6.2.7 -y >> /tmp/${COMPONENT}.log
stat $?
# vim /etc/redis.conf
# vim /etc/redis/redis.conf

echo -n "enabling the ${COMPONENT}: "
systemctl enable redis
stat $?

echo -n "Starting the ${COMPONENT}: "
systemctl start redis
stat $?

echo -n "Checking the ${COMPONENT} status: "
systemctl status redis -l
stat $?