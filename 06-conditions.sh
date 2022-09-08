#!/bin/bash

case $ACTION in 
   start)
     echo "Starting XY Service"
     ;;
    stop)
      echo "Stopping XYZ Service"
      ;;
    restart)
      echo "restarting XYZ service"
      ;;
      *)
      echo "vaild options are start or stop or restart only"
esac
