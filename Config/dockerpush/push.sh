#! /bin/bash

echo "$DOCKER_CRED_PSW" | docker login -u $DOCKER_CRED_USR --password-stdin
# it will take the cred from the Jenkinsfile. 

docker push muthuinc/devopsthon:v1  # this is the name of my dockerhub repo


docker logout

echo "pushed successfully"