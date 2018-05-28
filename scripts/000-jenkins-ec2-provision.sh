#!/bin/bash
sudo yum update -y \
&& sudo yum install docker git -y \
&& sudo systemctl enable docker \
&& sudo systemctl start docker \
&& git clone https://github.com/maxstack/docker-jenkins.git \
&& cd docker-jenkins \
&& sed -i -e 's/_USERNAME_/admin/g' security.groovy \
&& sed -i -e 's/_PASSWORD_/somecomplexpassword/g' security.groovy \
&& sudo docker build --build-arg GID=$(grep docker /etc/group | cut -d: -f3) -t jenkins:lts-automated . \
&& sudo docker run -d -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --restart unless-stopped --name jenkins -p 8080:8080 -p 50000:50000 jenkins:lts-automated
