#!groovy

node {

  env.PACKER_CMD = "docker run -v $HOME/.aws:/root/.aws:ro  --rm --network host -w /app -v ${WORKSPACE}:/app hashicorp/packer:light"

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
    cleanWs()
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

    stage ("Archive build output") {
      // Archive the build output artifacts.
      archiveArtifacts artifacts: 'manifest.json'
    }

    cleanWs()
  }

  if (env.desiredAction == 'destroyPacker') {

    def exists = fileExists '../../jobs/"env.JOB_NAME"/lastSuccessful/archive/manifest.json'

    if (exists) {
      stage ('Copy artifacts if they exist') {
        step([$class: 'CopyArtifact', optional: true, filter: 'manifest.json', fingerprintArtifacts: true, flatten: true, projectName: env.JOB_NAME, selector: lastSuccessful()])
      }
    } else {
      stage ('Abort') {
        currentBuild.result = 'ABORTED'
        error('ABORTING. Please run buildPacker first.')
        }
      }

    stage ('cat info') {
      ansiColor('xterm') {
        sh 'cat manifest.json'
      }
    }

//    // Optional wait for approval
//    input 'Destroy packer image?'
//
//    stage ('Packer destroy') {
//      ansiColor('xterm') {
//        sh 'aws build jenkins-packer-ec2.json'
//      }
//    }
//
//    stage ("Archive build output") {
//      // Archive the build output artifacts.
//      archiveArtifacts artifacts: 'manifest.json'
//    }
//
//    cleanWs()
//  }
  }


}
