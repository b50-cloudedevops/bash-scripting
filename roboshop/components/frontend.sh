#!/bin/bash

ID=$(id -u)
if [ "$ID" -ne "0" ]; then 
  echo "Try to execute the script with sudo user or root user"
  exit 1
fi
yum install nginx -y
systmectl enable nginx
systemctl start nginx
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
systemctl restart nginx