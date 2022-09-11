ID=$(id -u)
if [ "$ID" -ne "0" ]; then 
  echo "Try to execute the script with sudo user or root user"
  exit 1
fi


stat() {
if [ $? -eq 0 ]; then
  echo -e "Success"
else
 echo -e "failure, look for the logs"
fi
}