#!/bin/bash

#[-z "$var"]
#[-n "$var"]

ACTION=$1
#if [ "$ACTION" = "start" ] ; then
# echo "selected choice is start"
# exit 2
#elif [ "$ACTION" = "stop" ] ; then
  echo "selected choice is stop"
  exit 1
#else 
# echo "only valid option is start"
# exit 2
#fi

#-z will be true, if the supplied input is null
if [-z $ACTION ]; then
echo "Argument is needed" 
fi