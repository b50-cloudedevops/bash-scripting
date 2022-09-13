#!/bin/bash
set -e
source components/common.sh
COMPONENT=redis
echo -n "Configuring the $COMPONENT repo:"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?

echo -n "Installing $COMPONENT"
yum install redis-6.2.7 -y >> /tmp/${COMPONENT}.log
stat $?
# vim /etc/redis.conf
# vim /etc/redis/redis.conf
# systemctl enable redis
# systemctl start redis
# systemctl status redis -l