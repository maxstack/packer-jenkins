#!groovy

node {

  env.PACKER_CMD = "docker run -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --rm --network host -w /app -v ${WORKSPACE}:/app hashicorp/packer:light"

  stage ('Checkout') {
    checkout scm
  }

  if (env.desiredAction == 'validatePacker') {
    stage ('pull latest light packer image') {
      ansiColor('xterm') {
        sh 'docker pull hashicorp/packer:light'
      }
    }

    stage ('Packer validate') {
      ansiColor('xterm') {
        sh '${PACKER_CMD} validate jenkins-packer-ec2.json'
      }
    }
//    cleanWs()
  }

  if (env.desiredAction == 'buildPacker') {
    stage ('pull latest light packer image') {
      ansiColor('xterm') {
        sh 'docker pull hashicorp/packer:light'
      }
    }

    stage ('Packer validate') {
      ansiColor('xterm') {
        sh '${PACKER_CMD} validate jenkins-packer-ec2.json'
      }
    }

    // Optional wait for approval
    input 'Deploy stack?'

    stage ('Packer build') {
      ansiColor('xterm') {
        sh '${PACKER_CMD} build jenkins-packer-ec2.json'
      }
    }
//    cleanWs()
  }
}
