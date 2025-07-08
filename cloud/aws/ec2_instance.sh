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
  --launch-template-name my-app-template \
  --version-description v1 \
  --launch-template-data '{
    "ImageId":"ami-010876b9ddd38475e",
    "InstanceType":"t3.micro",
    "KeyName":"my-keypair",
    "IamInstanceProfile":{"Name":"EC2ECRRole"},
    "UserData":"'"$USER_DATA"'",
    "SecurityGroupIds":["sg-0123456789abcdef0"],
    "TagSpecifications":[
      {
        "ResourceType":"instance",
        "Tags":[{"Key":"Name","Value":"my-app-instance"}]
      }
    ]
  }'



# launch a template
aws ec2 run-instances --launch-template LaunchTemplateName=my-app-template,Version=1 --count 1


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



