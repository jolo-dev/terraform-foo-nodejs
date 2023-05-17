#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install ansible2 -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chmod 666 /var/run/docker.sock

# Replace the following with your own S3 bucket name
aws s3 cp s3://aws-terraform-jolo/app.zip /home/ec2-user/app.zip
unzip /home/ec2-user/app.zip -d /home/ec2-user/

cd app
docker build -t app .
docker run -d -p 80:3000 -e PORT=3000 -e DB_USERNAME=pete -e DB_PASSWORD=devops app