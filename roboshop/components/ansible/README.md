# ansible

Ansible 6.0 is python 3 based and installation of python 3 is needed.


...............
###Inventory File: This is the file which we supply ansible the list of DNS Names or IPs on the machine that you would like to do that configuration management. The default group in this file is 'all' which included all the DNS or IP's that you supplied.

#Ansible can be operated in 2 ways.

Manual way: (executing the commands and can work one command at a time)
Automated way: (using Ansible playbook)

### Simple Ansible Manual command
ansible all -i inv -e ansible_user=centos -e ansible_password=DevOps321 -m shell -a "df -h"
-i-- Inventory file
-m-- Module
-a--argument

PS: ansible --help gives you all the latest and greatest option of that use
-------------

### Pre-requisites

The very first thing we need to ensure that ANSIBLE works is: SSH. Your ansible should be able  to SSH to the entries mentioned in your inventory file


### Playbooks are nothing but your ansible scripts which are written on YAML
YAML: Yet Another Markup Language
----
Dictionary: A key value pair is called as dictionary
List: A key with multiple values is called as a list
Map: A key with multiple key value pairs is referred as MAP

----
Playbook is a list of plays.

What is a play ? A play is a list of tasks.

What is a task ? A Task is an action or actions that you wish to do 