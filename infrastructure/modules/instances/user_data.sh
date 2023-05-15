#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chmod 666 /var/run/docker.sock
docker pull nginx
docker tag nginx my-nginx
docker run --rm --name nginx-server -d -p 80:80 -t my-nginx