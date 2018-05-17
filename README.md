# packer-jenkins

A packer project to pack an AMI based on LTS Amazon Linux, with jenkins preinstalled via docker.

## Getting Started

Export your AWS environment variables (if they aren't already in .aws), make sure to add a space before the command so it doesn't show up in history.

```
 export AWS_ACCESS_KEY_ID=
 export AWS_SECRET_ACCESS_KEY=
```

Run the following commands to set the Jenkins username and password
```
sed -i -e 's/_NEW_USERNAME_/admin/g' scripts/000-jenkins-ec2-provision.sh
sed -i -e 's/_NEW_PASSWORD_/somecomplexpassword/g' scripts/000-jenkins-ec2-provision.sh
```

Edit jenkins-packer-ec2.json and change the region if required.

Next validate your file then build!
```
packer validate jenkins-packer-ec2.json
packer build jenkins-packer-ec2.json
```
