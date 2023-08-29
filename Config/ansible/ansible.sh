#!/bin/bash



a=$(aws ec2 describe-instances --region ap-southeast-2 --filters "Name=tag:Name,Values=app1" --query 'Reservations[].Instances[].PublicIpAddress' --output text)
# store the ip address of the instance based on the above query

echo $a
cat inventory.txt

#ansible-playbook --private-key=$Muthu --user=ubuntu --extra-vars="ansible_host=$a" ansible.yml

sed -i "s/muthuu/$a/g" inventory.txt
# inserting the dynamically created ip to the inventory.txt file 

cat inventory.txt

