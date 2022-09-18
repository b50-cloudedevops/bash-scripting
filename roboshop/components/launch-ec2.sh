#!/bin/bash
# AMI_ID=ami-00ff427d936335825
if [ -z  "$1" ]; then
 echo -e  "Input machine name is missing: "
 exit 1
fi 

COMPONENT=$1
ZONEID="Z0175006XAWHYA3OXLXM"
AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
echo "AMI Id which is fetched $AMI_ID"
SGID="sg-0c45f649a0dc57860"

echo "The AMI which we are using is $AMI_ID"
create_server() {
  PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t3.micro --security-group-ids ${SGID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
  echo "Private IP of created machine is $PRIVATE_IP"
  echo "Spot Instance $COMPONENT is ready: "
  echo "Creating Route53 Record........"

  sed -e "s/PRIVATEIP/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" r53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONEID} --change-batch file:///tmp/record.json | jq

}

if [ "$1" = "all" ] ; then
  for component in catalogue cart shipping frontend mongodb payment rabbitmq redis mysql user; do 
    COMPONENT=$component 
    create_server
  done
else
   create_server
fi 
