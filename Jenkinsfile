#!groovy

node {

  env.PACKER_CMD = "docker run --rm --network host -w /app -v ${WORKSPACE}:/app hashicorp/packer:light"

  stage ('Checkout') {
    checkout scm
  }

  if (env.desiredAction == 'validatePacker') {
    stage ('pull latest light packer image') {
      ansiColor('xterm') {
        sh 'docker pull hashicorp/packer:light'
      }
    }


    stage('Validate packer build') {
        steps {
          withCredentials([
            usernamePassword(credentialsId: 'a0900f2c-b2a9-40a7-9fed-71209031b03c', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY')
          ]) {
            sh 'packer validate -var aws_access_key=${AWS_KEY} -var aws_secret_key=${AWS_SECRET} jenkins-packer-ec2.json'
        }
      }
    }

  }
}
