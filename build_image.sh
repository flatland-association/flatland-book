#!/bin/bash


export IMAGE_TAG=`git rev-parse --short HEAD`
export IMAGE_NAME="aicrowd/flatland-docs:$IMAGE_TAG"
docker build -t "$IMAGE_NAME" . -f deploy/Dockerfile
docker push $IMAGE_NAME


echo "Deploy by: "
echo "export IMAGE_TAG='$IMAGE_TAG'"
echo "envsubst < deploy/kube-deploy.yaml | kubectl apply -f -"


