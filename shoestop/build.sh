#!/bin/bash

# creating the docker image with the same name of my docker hub repo
docker build -t muthuinc/devopsthon:v1 .

echo "image created successfully"
