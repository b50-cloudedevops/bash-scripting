ID=$(id -u)
if [ "$ID" -ne "0" ]; then 
  echo "Try to execute the script with sudo user or root user"
  exit 1
fi


stat() {
if [ $1 -eq 0 ]; then
  echo -e "Success"
else
 echo -e "failure, look for the logs"
fi
}

FUSER=roboshop
LOGFILE=/tmp/robot.log

USER_SETUP() {
  echo -n " Adding ${FUSER} user: "
  id ${FUSER} &>> /tmp/${COMPONENT}.log || useradd ${FUSER}
  stat $?
}
DOWNLOAD_AND_EXTRACT() {
  echo -n "Downloading $COMPONENT: "
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
  stat $?

 echo -n "Clean up of old $COMPONENT content:"
 rm -rf /home/${FUSER}/${COMPONENT} >> /tmp/${COMPONENT}.log
 stat $?

 echo -n "Extracting $COMPONENT content: "
 cd /home/${FUSER}
 unzip -o /tmp/${COMPONENT}.zip >> /tmp/${COMPONENT}.log  &&  mv ${COMPONENT}-main ${COMPONENT}  >>  /tmp/${COMPONENT}.log
 stat $?

 echo -n "Changing the ownership to $FUSER: "
 chown -R $FUSER:$FUSER $COMPONENT/
 stat $?
}

CONFIG_SVC() {
  echo -n "configuring the systemd file: "
  sed -i -e 's/CARTHOST/cart.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/'  -e 's/USERHOST/user.roboshop.internal/' -e  's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/'  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/${FUSER}/${COMPONENT}/systemd.service
  mv /home/${FUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  stat $?

  echo -n "Starting the service: "
  systemctl daemon-reload &>> /tmp/${COMPONENT}.log
  systemctl enable $COMPONENT &>> /tmp/${COMPONENT}.log
  systemctl start $COMPONENT &>> /tmp/${COMPONENT}.log
  stat $?
}
NODEJS() {
  echo -n " Configuring Yum repos for nodejs: "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash   >> /tmp/${COMPONENT}.log
  stat $?

  echo -n "Installing nodejs: " 
  yum install nodejs -y >> /tmp/${COMPONENT}.log
  stat $?
  USER_SETUP
  DOWNLOAD_AND_EXTRACT
  echo -n "Installing $COMPONENT Dependencies: "
  cd $COMPONENT && npm install >> /tmp/${COMPONENT}.log
  stat $?

  CONFIG_SVC
}

MAVEN() {
echo -n "Installing Maven: "
yum install maven -y &>> ${LOGFILE}
stat $?

USER_SETUP
DOWNLOAD_AND_EXTRACT
echo -n "Generating the artifact: "
cd /home/${FUSER}/${COMPONENT}
mvn clean package &>> ${LOGFILE}
mv target/$COMPONENT-1.0.jar $COMPONENT.jar
stat $?

CONFIG_SVC

echo -e "\n *********$COMPONENT Installation completed*********************\n"

}
PYTHON() {

  echo -n "Installing python!: "
yum install python36 gcc python3-devel -y >> ${LOGFILE}
stat $?

USER_SETUP

DOWNLOAD_AND_EXTRACT

cd /home/${FUSER}/${COMPONENT}
pip3 install -r requirements.txt >> ${LOGFILE}
stat $?

USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)

echo -n "Updating the $COMPONENT file: "
sed -e "/^uid/ c uid=${USER_ID}" -e "/^gid/ c gid=${GROUP_ID}" payment.ini 
stat $?
CONFIG_SVC

}