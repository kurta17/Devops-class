pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    stages {
        stage('Test') {
              steps {
                   sh "go test ./..."
              }
        }
        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }
        stage('Deploy') {
          steps {
              withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@43.209.213.135 "sudo systemctl stop myapp" || true' 
                sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@43.209.213.135:'
            }
          }
        }
    }
}
