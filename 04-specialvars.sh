#!/bin/bash
#$0 This gives you the name of the script your'e running
#$1 to $9 : you can pass a maximum of 9 variables from the command line when you are running the script
#$* 
#$@
#$#
#$$
echo "script name that you are running is $0"
a=10
b=$1
c=$2
d=$3
echo value of a is : $a
echo value of b is : $b
echo value of c is : $c
echo value of d is : $d

