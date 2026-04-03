#!/bin/bash
BRANCH=${1:-main}

echo "Pulling latest code from $BRANCH..."
git checkout $BRANCH
git pull origin $BRANCH

echo "Building project ..."
mvn clean package -DskipTests

echo "Stop docker container ..."
docker stop farm-container || true
docker rm farm-container || true

echo "Building docker image ..."
docker rmi farm || true
docker build -t farm .

echo "Starting container ..."
docker run -d --name farm-container -p 8080:8080 -v ~/Filebase:/Filebase --env-file ~/farm.env farm

echo ""
echo "Done."