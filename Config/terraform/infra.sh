#!/bin/bash

terraform init && terraform apply --auto-approve

echo " success"

sleep 5  # this time is usefull for the instance to start up 

a=$(aws ec2 describe-instances --region ap-southeast-2 --filters "Name=tag:Name,Values=app1" --query 'Reservations[].Instances[].PublicIpAddress' --output text)

echo "$a"

# the instance public ip will be displayed in the output
