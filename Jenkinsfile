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
                    sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@43.210.19.225 "sudo systemctl stop myapp" || true'
                    sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@43.210.19.225 "sudo systemctl start myapp" || true'
                    sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@43.210.19.225:'
                }
            }
        }
    }
}
