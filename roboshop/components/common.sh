ID=$(id -u)
if [ "$ID" -ne "0" ]; then 
  echo "Try to execute the script with sudo user or root user"
  exit 1
fi