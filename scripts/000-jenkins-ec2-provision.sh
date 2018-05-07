#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull jenkins/jenkins:lts
sudo docker volume create jenkins_home
sudo docker run -d -v jenkins_home:/var/jenkins_home --restart unless-stopped --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
