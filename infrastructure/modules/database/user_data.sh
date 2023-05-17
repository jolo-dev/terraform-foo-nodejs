#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chmod 666 /var/run/docker.sock

docker run -d -p 5432:5432 -e POSTGRES_USER=pete -e POSTGRES_PASSWORD=devops -e POSTGRES_DB=foo postgres:14.7

