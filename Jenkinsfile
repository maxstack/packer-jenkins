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

    def exists = fileExists "../../jobs/${env.JOB_NAME}/lastSuccessful/archive/manifest.json"
//    def exists = fileExists "../../jobs/sample/builds/8/archive/manifest.json"


    if (exists) {
      stage ('Copy artifacts if they exist') {
        step([$class: 'CopyArtifact', optional: true, filter: 'manifest.json', fingerprintArtifacts: true, flatten: true, projectName: env.JOB_NAME, selector: lastSuccessful()])
      }
      stage ('Set some artifact variables if they exist') {
        AMI_ID = sh(returnStdout: true, script: """grep artifact_id ../../jobs/$JOB_NAME/builds/lastSuccessfulBuild/archive/manifest.json  | awk '{print \$2}' |  sed 's/"//g' | sed 's/,//g' |cut -d':' -f2""").trim()
        AMI_REGION = sh(returnStdout: true, script: """grep artifact_id ../../jobs/$JOB_NAME/builds/lastSuccessfulBuild/archive/manifest.json  | awk '{print \$2}' |  sed 's/"//g' | sed 's/,//g' |cut -d':' -f1""").trim()
        PACKER_RUN_UUID = sh(returnStdout: true, script: """grep packer_run_uuid ../../jobs/$JOB_NAME/builds/lastSuccessfulBuild/archive/manifest.json  | awk '{print \$2}' |  sed 's/"//g' | sed 's/,//g'""").trim()
        SNAP_ID = sh(returnStdout: true, script: """aws ec2 describe-images --filter Name=tag:packer_run_uuid,Values=${PACKER_RUN_UUID} | jq ".Images[0].ImageId,.Images[0].BlockDeviceMappings[0].Ebs.SnapshotId" | sed -n '2 p' | sed 's/"//g'""").trim()
      }
    } else {
      stage ('Abort') {
        currentBuild.result = 'ABORTED'
        error('ABORTING. Please run buildPacker first.')
        }
      }

    stage ('Destroy AMI') {
      ansiColor('xterm') {
        sh "aws ec2 deregister-image --image-id ${AMI_ID}"
        sh "aws ec2 delete-snapshot --snapshot-id ${SNAP_ID}"
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
    cleanWs()
//  }
  }


}
