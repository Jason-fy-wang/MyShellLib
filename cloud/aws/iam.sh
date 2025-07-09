
# create policy 
aws iam create-policy \
  --policy-name AllowPassRoleToEC2 \
  --policy-document '{
    "Version":"2012-10-17",
    "Statement":[
      {
        "Effect":"Allow",
        "Action":"iam:PassRole",
        "Resource":"arn:aws:iam::233574659475:role/ec2operator"
      }
    ]
  }'

# 记下输出中的 PolicyArn，然后附加给用户或组
## assign policy (output from above) to user
aws iam attach-user-policy \
  --user-name ec2operator \
  --policy-arn arn:aws:iam::233574659475:policy/AllowPassRoleToEC2
