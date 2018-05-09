#!/bin/bash

sudo yum update -y
sudo yum install docker git -y
sudo systemctl enable docker
sudo systemctl start docker
git clone https://github.com/maxstack/docker-jenkins.git
cd docker-jenkins
sed -i -e 's/_USERNAME_/admin/g' security.groovy
sed -i -e 's/_PASSWORD_/somecomplexpassword/g' security.groovy
sudo docker build -t jenkins:lts-automated .
sudo docker volume create jenkins_home
sudo docker run -d -v jenkins_home:/var/jenkins_home --restart unless-stopped --name jenkins -p 8080:8080 -p 50000:50000 jenkins:lts-automated
