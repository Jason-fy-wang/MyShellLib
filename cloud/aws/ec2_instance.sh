#!/usr/bin/env bash

# ec2 help
aws ec2 help

# list all instances
aws ec2 describe-instances --output table

aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,Type:InstanceType,State:State.Name,PrivateIP:PrivateIpAddress,PublicIp:PublicIpAddress,Name: Tags.Name, Zone: Placement.AvailabilityZone}' --output table

# delete instance
aws ec2 terminate-instances --instance-ids i-0abcdef1234567890

# create template and add start cloud-init
USER_DATA=$(base64 -w0 startup.yaml)

aws ec2 create-launch-template \
  --launch-template-name web-template \
  --version-description v1 \
  --launch-template-data '{
    "ImageId":"ami-010876b9ddd38475e",
    "InstanceType":"t3.micro",
    "KeyName":"awk_key",
    "IamInstanceProfile":{"Name":"ec2operator"},
    "UserData":"'"$USER_DATA"'",
    "SecurityGroupIds":["sg-087330d8b600153d3","sg-07ca421081cc7a04f"],
    "TagSpecifications":[
      {
        "ResourceType":"instance",
        "Tags":[{"Key":"Name","Value":"web2"}]
      }
    ]
  }'

# list instance-template
aws ec2 describe-launch-templates

aws ec2 delete-launch-template --launch-template-id 

# launch a template
aws ec2 run-instances --launch-template LaunchTemplateName=web-template,Version=1 --count 1

# decrypt
aws ec2 describe-launch-template-versions \
  --launch-template-name web-template \
  --versions 1 \
  --query 'LaunchTemplateVersions[0].LaunchTemplateData.UserData' \
  --output text \
  | base64 --decode > retrieved_startup.yaml

# images
## for below query
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      "Resource": "arn:aws:ssm:ap-southeast-2:*:parameter/aws/service/canonical/ubuntu/*"
    }
  ]
}

aws iam attach-user-policy \
  --user-name ec2operator \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess


aws ssm get-parameter --name  /aws/service/canonical/ubuntu/server/*/stable/current/amd64/hvm/ebs-gp2/ami-id --output table

aws ec2 describe-images --owner 099720109477 --filter "Name=name,Values=ubuntu/images/hvm-ssd-gp3/*24*amd64*" --output table



