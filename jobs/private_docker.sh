#!/bin/bash

DOCKER_REGISTRY_SERVER=docker.io

echo "Docker User:"
read DOCKER_USER

echo "Docker email:"
read DOCKER_EMAIL

echo "Docker Password:"
read DOCKER_PASSWORD

kubectl create secret docker-registry myregistrykey \
  --docker-server=$DOCKER_REGISTRY_SERVER \
  --docker-username=$DOCKER_USER \
  --docker-password=$DOCKER_PASSWORD \
  --docker-email=$DOCKER_EMAIL
