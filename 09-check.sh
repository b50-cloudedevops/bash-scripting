#!/bin/bash

ID=$(id -u)
if [ $ID -eq: 0 ]; then 
 echo "Exceuting httpd installation"
 yum install httpd -y
else 
 echo -e "try Executing the script with sudo or a root user"
 exit 1
fi
