pipeline {
    agent any
    tools {
        go "1.24.1"
    }
    environment {
        IMAGE = "ttl.sh/myapp-${BUILD_NUMBER}:2h"  // Unique per build
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
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE} ."
                sh "docker push ${IMAGE}"
            }
        }
        stage('Docker Run Image') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker '
                            docker pull ${IMAGE}
                            docker stop myapp || true
                            docker rm myapp || true
                            docker run --name myapp --detach --publish 4444:4444 ${IMAGE}
                        '
                    """
                }
            }
        }
    }
}
