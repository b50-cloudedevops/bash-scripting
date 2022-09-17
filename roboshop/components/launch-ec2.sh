#!/bin/bash
# AMI_ID=ami-00ff427d936335825
AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
echo "AMI Id which is fetched $AMI_ID"