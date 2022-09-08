#!/bin/bash
/*case $var in
  cond1)
    command1 ;;
  cond2)
     command2 ;;
   *)
   ec2;;
esac
*/
case $ACTION in 
   start)
     echo "Starting XY Service"
     ;;
    stop)
      echo "Stopping XYZ Service"
      ;;
    restart)
      echo "restarting XYZ service"
esac
