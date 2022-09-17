#!/bin/bash
# AMI_ID=ami-00ff427d936335825
if [ -z  "$1" ]; then
 echo -n "Input machine name is missing: "
 exit 1
fi 
COMPONENT=$1
AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
echo "AMI Id which is fetched $AMI_ID"
SGID="sg-0c45f649a0dc57860"
aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SGID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" | jq 

echo "Spot Instance $COMPONENT is ready: "