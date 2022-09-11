#!/bin/bash
set -e # ensures your script will stop if any of the instruction fails
source components/common.sh
echo -n "Installing nginx: "
yum install nginx -y >> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "Success"
else
 echo -e "failure, look for the logs"
fi
systemctl enable nginx
echo -n "starting nginx: "
systemctl start nginx
if [ $? -eq 0 ]; then
  echo -e "Success"
else
 echo -e "failure, look for the logs"
fi

echo -n "Downloading the code: "
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
if [ $? -eq 0 ]; then
  echo -e "Success"
else
 echo -e "failure, look for the logs"
fi
cd /usr/share/nginx/html
rm -rf *
unzip -o /tmp/frontend.zip  >>  /tmp/frontend.log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf  /etc/nginx/default.d/roboshop.conf
if [ $? -eq 0 ]; then
  echo -e "Success"
else
 echo -e "failure, look for the logs"
fi
systemctl restart nginx