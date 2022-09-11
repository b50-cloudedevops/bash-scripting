#!/bin/bash
set -e # ensures your script will stop if any of the instruction fails
source components/common.sh
echo -n "Installing nginx: "
yum install nginx -y >> /tmp/frontend.log
stat $?
systemctl enable nginx
echo -n "starting nginx: "
systemctl start nginx
stat $?
echo -n "Downloading the code: "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?
cd /usr/share/nginx/html
rm -rf *
unzip -o /tmp/frontend.zip  >>  /tmp/frontend.log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf  /etc/nginx/default.d/roboshop.conf 
systemctl restart nginx
echo "staring the nginx"
stat $?
