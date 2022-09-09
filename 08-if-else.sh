#!/bin/bash

#[-z "$var"]
#[-n "$var"]

ACTION=$1
if [ "$ACTION" = "start" ] ; then
 echo "selected choice is start"
elif [ "$ACTION" = "stop" ] ; then
  echo "selected choice is stop"
else 
 echo "only valid option is start"
fi